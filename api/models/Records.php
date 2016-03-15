<?php




use Phalcon\Mvc\Model\Validator\Regex;
use Phalcon\Mvc\Model\Validator\PresenceOf;




class Records extends AppModel {
	public $id;
	public $user_id;
	public $text;
	public $datetime;
	public $calories;



	public function initialize() {
		$this->belongsTo('user_id', 'Users', 'id');
		$this->setup([
			'notNullValidations'	=> false
		]);
	}



	public function validation() {
		$this->validate(new PresenceOf([
			'field'		=> 'text',
			'message'	=> 'Text is required'
		]));
		$this->validate(new PresenceOf([
			'field'		=> 'datetime',
			'message'	=> 'Date & time is required'
		]));
		$this->validate(new Regex([
			'pattern'	=> '/^([\+-]?\d{4}(?!\d{2}\b))((-?)((0[1-9]|1[0-2])(\3([12]\d|0[1-9]|3[01]))?|W([0-4]\d|5[0-2])(-?[1-7])?|(00[1-9]|0[1-9]\d|[12]\d{2}|3([0-5]\d|6[1-6])))([T\s]((([01]\d|2[0-3])((:?)[0-5]\d)?|24\:?00)([\.,]\d+(?!:))?)?(\17[0-5]\d([\.,]\d+)?)?([zZ]|([\+-])([01]\d|2[0-3]):?([0-5]\d)?)?)?)?$/',
			'field'		=> 'datetime',
			'message'	=> 'Date & time is invalid'
		]));
		$this->validate(new PresenceOf([
			'field'		=> 'calories',
			'message'	=> 'Calories is required'
		]));
		$this->validate(new Regex([
			'pattern'	=> '/^[0-9]*\.?[0-9]+$/',
			'field'		=> 'calories',
			'message'	=> 'Calories is invalid'
		]));

		return $this->validationHasFailed() != true;
	}



	public function beforeSave() {
		if (isset($this->datetime) && $this->datetime)
			$this->datetime		= date('Y-m-d H:i:s', strtotime($this->datetime));
	}



	public function afterFetch() {
		if (isset($this->datetime) && $this->datetime)
			$this->datetime		= date('c', strtotime($this->datetime));
	}



	public function toOutput() {
		$permissionValue	= $this->permissionForAction();

		if ($permissionValue == Permissions::ACCESS_NO_ACCESS)
			return null;

		$user				= $this->authorizedUser();

		if ($permissionValue == Permissions::ACCESS_ALL_RECORDS || (isset($user->id) && $user->id == $this->user_id)) {
			$this->afterFetch();

			$result				= [
				'Record'			=> [
					'id'				=> intval($this->id),
					'user_id'			=> intval($this->user_id),
					'text'				=> $this->text,
					'datetime'			=> $this->datetime,
					'calories'			=> floatval($this->calories)
				]
			];

			$owner				= $this->getUsers();

			if (($owner && isset($owner->id)) && $owner->id != $user->id) {
				$output				= $owner->toOutput();

				if ($output)
					$result				= array_merge($result, $output);
			}

			return $result;
		}

		return null;
	}
}
<?php




use Phalcon\Mvc\Model\Validator\Uniqueness;
use Phalcon\Mvc\Model\Validator\PresenceOf;
use Phalcon\Mvc\Model\Validator\Email;




class Users extends AppModel {
	private $_validatePassword = true;

	public $id;
	public $group_id;
	public $name;
	public $email;
	public $password;
	public $calories_per_day;



	public function initialize() {
		$this->belongsTo('group_id', 'Groups', 'id');
		$this->setup([
			'notNullValidations'	=> false
		]);
	}



	public function noValidatePassword() {
		$this->_validatePassword	= false;
	}



	public function validatePassword() {
		$this->_validatePassword	= true;
	}



	public function validation() {
		$this->validate(new PresenceOf([
			'field'		=> 'email',
			'message'	=> 'Email is required'
		]));
		$this->validate(new Email([
			'field'		=> 'email',
			'message'	=> 'Invalid email'
		]));
		$this->validate(new Uniqueness([
			'field'		=> 'email',
			'message'	=> 'The email must be unique'
		]));

		$this->validate(new PresenceOf([
			'field'		=> 'name',
			'message'	=> 'Name is required'
		]));

		if ($this->_validatePassword)
			$this->validate(new PresenceOf([
				'field'		=> 'password',
				'message'	=> 'Password is required'
			]));

		return $this->validationHasFailed() != true;
	}



	public static function passwordHash($password) {
		return md5($password);
	}



	public function beforeSave() {
		if ($this->_validatePassword) {
			if (isset($this->password) && $this->password)
				$this->password		= Users::passwordHash($this->password);
		}
	}



	public function toOutput() {
		$permissionValue	= $this->permissionForAction();

		if ($permissionValue == Permissions::ACCESS_NO_ACCESS)
			return null;

		$user				= $this->authorizedUser();

		if ($permissionValue == Permissions::ACCESS_ALL_RECORDS || (isset($user->id) && $user->id == $this->id)) {
			$result				= [
				'User'				=> [
					'id'				=> intval($this->id),
					'name'				=> $this->name,
					'email'				=> $this->email,
					'calories_per_day'	=> floatval($this->calories_per_day)
				]
			];

			$groups				= $this->getGroups()->toOutput();

			if ($groups)
				$result				= array_merge($result, $groups);

			return $result;
		}

		return null;
	}
}
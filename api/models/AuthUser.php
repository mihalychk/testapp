<?php




use Phalcon\Mvc\Model\Validator\PresenceOf;
use Phalcon\Mvc\Model\Validator\Email;




class AuthUser extends AppModel {
	public $email;
	public $password;



    public function validation() {
		$this->validate(new PresenceOf([
			'field'		=> 'email',
			'message'	=> 'Email is required'
		]));
		$this->validate(new Email([
			'field'		=> 'email',
			'message'	=> 'Invalid email'
		]));

		$this->validate(new PresenceOf([
			'field'		=> 'password',
			'message'	=> 'Password is required'
		]));

		return $this->validationHasFailed() != true;
	}
}
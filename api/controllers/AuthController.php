<?php




class AuthController extends AppController {



	private function startNewSession($user) {
		$this->session->start();
		$this->session->regenerateId(true);
		$this->session->set('User', $user);

		$result				= $user->toOutput();
		$result				= array_merge($result ? $result : [], [
			$this->config->session->name	=> $this->session->getId()
		]);

		$this->setResult($result);
	}



	public function infoAction() {
		$user				= $this->authorizedUser();

		if ($user)
			$this->setResult($user->toOutput());

		else
			$this->httpUnauthorized();

		return $this->respond();
	}



	public function registerAction() {
		$postData			= $this->getParams();
		$user				= new Users();
		$user->group_id		= $this->config->users->default_group_id;

		if (isset($postData->email))
			$user->email		= $postData->email;

		if (isset($postData->name))
			$user->name			= $postData->name;

		if (isset($postData->password))
			$user->password		= $postData->password;

		if ($user->create())
			$this->startNewSession($user);

		else {
			$errors				= [];

			foreach ($user->getMessages() as $message)
				$errors[]			= ValidationError::toOutput($message);

			$this->setErrors($errors);
			$this->httpBadRequest();
		}

		return $this->respond();
	}



	public function loginAction() {
		$postData			= $this->getParams();
		$auth				= new AuthUser();

		if (isset($postData->email))
			$auth->email		= $postData->email;

		if (isset($postData->password))
			$auth->password		= Users::passwordHash($postData->password);

		if ($auth->validation()) {
			$user				= Users::findFirst([
				'email = :email: AND password = :password:',
				'bind'				=> [
					'email'				=> $auth->email,
					'password'			=> $auth->password
				]
			]);

			if ($user && isset($user->id))
				$this->startNewSession($user);

			else
				$this->httpUnauthorized();
		}
		else {
			$errors				= [];

			foreach ($auth->getMessages() as $message)
				$errors[]			= ValidationError::toOutput($message);

			$this->setErrors($errors);
			$this->httpBadRequest();
		}

		return $this->respond();
	}



	public function logoutAction() {
		$user				= $this->authorizedUser();

		if ($user) {
			$this->session->destroy(true);
			$this->httpNoContent();
		}
		else
			$this->httpUnauthorized();

		return $this->respond();
	}

}
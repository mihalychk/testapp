<?php




class UsersController extends AppController {



	/* List all users */

	public function indexAction() {
		if ($this->authorizedUser()) {
			$users				= [];

			switch ($this->permissionForModelAndAction('users')) {
				case Permissions::ACCESS_MY_OWN_RECORDS:
					$users				= Users::find([
						'conditions'		=> 'id = :id:',
						'bind'				=> [
							'id'				=> $this->authorizedUser()->id
						]
					]);

					break;

				case Permissions::ACCESS_ALL_RECORDS:
					$users				= Users::find();

					break;

				default:
					$this->httpForbidden();

					break;
			}

			$result				= [];

			foreach ($users as $user) {
				$output				= $user->toOutput();

				if ($output)
					$result[]			= $output;
			}

			$this->setResult($result);
		}
		else
			$this->httpUnauthorized();

		return $this->respond();
	}



	/* Helpers */

	private function getById($user_id, $permissionAction) {
		if ($this->authorizedUser()) {
			$permissionValue	= $this->permissionForModelAndAction('users', $permissionAction);

			switch ($permissionValue) {
				case Permissions::ACCESS_MY_OWN_RECORDS:
				case Permissions::ACCESS_ALL_RECORDS:
					if ($permissionValue == Permissions::ACCESS_MY_OWN_RECORDS && $user_id != $this->authorizedUser()->id)
						$this->httpForbidden();

					else {
						$user				= Users::findFirst([
							'conditions'		=> 'id = :id:',
							'bind'				=> [
								'id'				=> $user_id
							]
						]);

						if (!$user)
							$this->httpNotFound();

						else
							return $user;
					}

					break;

				default:
					$this->httpForbidden();

					break;
			}
		}
		else
			$this->httpUnauthorized();

		return null;
	}



	private function prepareUser($permissionAction) {
		if ($this->authorizedUser()) {
			$permissionValue		= $this->permissionForModelAndAction('users', $permissionAction);

			if ($permissionValue == Permissions::ACCESS_NO_ACCESS)
				$this->httpForbidden();

			else {
				$postData				= $this->getParams('User');
				$user					= new Users();
		
				if (isset($postData->email))
					$user->email			= $postData->email;

				if (isset($postData->name))
					$user->name				= $postData->name;

				if (isset($postData->password))
					$user->password			= $postData->password;

				if (isset($postData->calories_per_day))
					$user->calories_per_day	= $postData->calories_per_day;

				if ($permissionValue == Permissions::ACCESS_ALL_RECORDS)
					if (isset($postData->group_id))
						$user->group_id			= $postData->group_id;

				return $user;
			}
		}
		else
			$this->httpUnauthorized();

		return null;
	}



	/* Create User */

	public function postAction() {
		$user				= $this->prepareUser(Permissions::ACTION_CREATE);

		if ($user) {
			if (!isset($user->group_id) || !$user->group_id)
				$user->group_id		= $this->config->users->default_group_id;
	
			if ($user->create()) {
				$this->httpCreated();
				$this->setResult($user->toOutput());
			}
			else {
				$errors				= [];
	
				foreach ($user->getMessages() as $message)
					$errors[]			= ValidationError::toOutput($message);
	
				$this->setErrors($errors);
				$this->httpBadRequest();
			}
		}

		return $this->respond();
	}



	/* Read User */

	public function viewAction($user_id) {
		$user				= $this->getById($user_id, Permissions::ACTION_READ);

		if ($user)
			$this->setResult($user->toOutput());

		return $this->respond();
	}



	/* Update User */

	public function putAction($user_id) {
		$user				= $this->getById($user_id, Permissions::ACTION_UPDATE);

		if ($user) {
			$postUser			= $this->prepareUser(Permissions::ACTION_UPDATE);
	
			if ($postUser) {
				$postUser->id		= $user->id;

				if (!isset($postUser->group_id) || !$postUser->group_id)
					$postUser->group_id	= $user->group_id;

				if (!isset($postUser->email) || !$postUser->email)
					$postUser->email	= $user->email;

				if (!isset($postUser->name) || !$postUser->name)
					$postUser->name		= $user->name;

				if (!isset($postUser->password) || !$postUser->password) {
					$postUser->password	= $user->password;

					$postUser->noValidatePassword();
				}

				if ($postUser->update()) {
					$this->httpOk();

					if ($postUser->id == $this->authorizedUser()->id)
						$this->session->set('User', $postUser);

					$this->setResult($postUser->toOutput());
				}
				else {
					$errors				= [];
		
					foreach ($postUser->getMessages() as $message)
						$errors[]			= ValidationError::toOutput($message);
		
					$this->setErrors($errors);
					$this->httpBadRequest();
				}

				$postUser->validatePassword();
			}
		}

		return $this->respond();
	}



	/* Delete User */

	public function deleteAction($user_id) {
		$user				= $this->getById($user_id, Permissions::ACTION_DELETE);

		if ($user) {
			if ($user_id == $this->authorizedUser()->id)
				$this->httpForbidden();

			else {
				if ($user->delete())
					$this->httpNoContent();
	
				else
					$this->httpInternalServerError();
			}
		}

		return $this->respond();
	}
}
<?php



use Phalcon\Mvc\Controller;



class AppController extends Controller {
	private $result;
	private $errors;



	/* Headers */

	public function httpOk() {
		$this->response->setStatusCode(200, 'OK')->sendHeaders();
	}



	public function httpCreated() {
		$this->response->setStatusCode(201, 'Created')->sendHeaders();
	}



	public function httpAccepted() {
		$this->response->setStatusCode(202, 'Accepted')->sendHeaders();
	}



	public function httpNoContent() {
		$this->response->setStatusCode(204, 'No Content')->sendHeaders();
	}



	public function httpBadRequest() {
		$this->response->setStatusCode(400, 'Bad Request')->sendHeaders();
	}



	public function httpUnauthorized() {
		$this->response->setStatusCode(401, 'Unauthorized')->sendHeaders();
	}



	public function httpForbidden() {
		$this->response->setStatusCode(403, 'Forbidden')->sendHeaders();
	}



	public function httpNotFound() {
		$this->response->setStatusCode(404, 'Not Found')->sendHeaders();
	}



	public function httpInternalServerError() {
		$this->response->setStatusCode(500, 'Internal Server Error')->sendHeaders();
	}



	/* Output Data */

	public function setResult($result = null) {
		if ($result && !empty($result))
			$this->result		= $result;
	}



	public function setErrors($errors = null) {
		if ($errors && !empty($errors))
			$this->errors		= $errors;
	}



	public function respond() {
		$return				= [];

		if ($this->result)
			$return['result']	= $this->result;

		if ($this->errors)
			$return['errors']	= $this->errors;

		return (!empty($return)) ? $return : null;
	}



	/* Sessions */

	public function authorizedUser() {
		return $this->session->get('User');
	}



	public function authorizedGroup() {
		$user			= $this->authorizedUser();

		if (!$user)
			return false;

		$group			= $user->getGroups();

		if (!$group)
			return false;

		return $group;
	}



	/* Permissions */

	public function permissionForModelAndAction($model, $action = Permissions::ACTION_READ) {
		$group			= $this->authorizedGroup();

		if (!$group)
			return false;

		$permissions	= $group->getPermissions();

		if (!$permissions || $permissions->count() < 1)
			return false;

		$result			= Permissions::ACCESS_NO_ACCESS;

		foreach ($permissions as $permission) {
			$value			= $permission->permissionForModelAndAction($model, $action);

			if ($value > $result)
				$result			= $value;
		}

		return $result;
	}



	/* Request Params */

	public function getParams($section = null) {
		$params			= $this->request->getJsonRawBody();

		if (!$section)
			return $params;

		return isset($params->{$section}) ? $params->{$section} : null;
	}

}
<?php




class RecordsController extends AppController {



	/* List all Records */

	public function indexAction() {
		if ($this->authorizedUser()) {
			$records			= [];
			$timeRegEx			= '/^([01]?[0-9]|2[0-3]):[0-5][0-9]$/';
			$time_from			= null;
			$time_to			= null;
			$date_from			= null;
			$date_to			= null;
			$time_condition		= [];

			if (preg_match($timeRegEx, $this->request->get('time_from')))
				$time_from			= $this->request->get('time_from');

			if (preg_match($timeRegEx, $this->request->get('time_to')))
				$time_to			= $this->request->get('time_to');

			if ($time_from || $time_to) {
				$time_from			= $time_from ? preg_split('/\:/', $time_from, -1, PREG_SPLIT_NO_EMPTY)[0] : null;
				$time_to			= $time_to ? preg_split('/\:/', $time_to, -1, PREG_SPLIT_NO_EMPTY)[0] : null;

				if (intval($time_from) < intval($time_to)) {
					$temp				= [];

					if ($time_from)
						$temp[]				= 'HOUR(datetime) >= '.$time_from;

					if ($time_to)
						$temp[]				= 'HOUR(datetime) <= '.$time_to;

					$time_condition		= '('.join(' AND ', $temp).')';
				}
				elseif (intval($time_from) > intval($time_to)) {
					$temp				= [];

					if ($time_from)
						$temp[]				= 'HOUR(datetime) >= '.$time_from;

					if ($time_to)
						$temp[]				= 'HOUR(datetime) <= '.$time_to;

					$time_condition[]	= '('.join(' OR ', $temp).')';
				}
			}

			$date_from			= strtotime($this->request->get('date_from'));
			$date_to			= strtotime($this->request->get('date_to'));

			if ($date_from || $date_to) {
				if (intval($date_from) <= intval($date_to)) {
					$temp				= [];

					if ($date_from)
						$temp[]				= 'datetime >= DATE(\''.date('Y-m-d H:i:s', $date_from).'\')';

					if ($date_to)
						$temp[]				= 'datetime <= DATE(\''.date('Y-m-d H:i:s', $date_to).'\')';

					$time_condition[]	= '('.join(' AND ', $temp).')';
				}
				else {
					$time_condition[]	= '1 = 2';
				}
			}

			$time_condition		= $time_condition ? (is_array($time_condition) ? join(' AND ', $time_condition) : $time_condition) : '1 = 1';
			//pr($time_condition);

			switch ($this->permissionForModelAndAction('records')) {
				case Permissions::ACCESS_MY_OWN_RECORDS:
					$records			= Records::find([
						'conditions'		=> 'user_id = :user_id: AND'.$time_condition,
						'bind'				=> [
							'user_id'			=> $this->authorizedUser()->id
						],
						'order'				=> 'datetime DESC'
					]);

					break;

				case Permissions::ACCESS_ALL_RECORDS:
					$records			= Records::find([
						'conditions'		=> $time_condition,
						'order'				=> 'datetime DESC'
					]);

					break;

				default:
					$this->httpForbidden();

					break;
			}

			$result				= [];

			foreach ($records as $record) {
				$output				= $record->toOutput();

				if ($output)
					$result[]			= $output;
			}

			return ['result' => $result];
		}
		else
			$this->httpUnauthorized();

		return $this->respond();
	}



	/* Helpers */

	private function getById($record_id, $permissionAction) {
		if ($this->authorizedUser()) {
			$permissionValue	= $this->permissionForModelAndAction('records', $permissionAction);

			switch ($permissionValue) {
				case Permissions::ACCESS_MY_OWN_RECORDS:
				case Permissions::ACCESS_ALL_RECORDS:
					$record				= Records::findFirst([
						'conditions'		=> 'id = :id:',
						'bind'				=> [
							'id'				=> $record_id
						]
					]);

					if (!$record)
						$this->httpNotFound();

					else {
						if ($permissionValue == Permissions::ACCESS_MY_OWN_RECORDS && $record->user_id != $this->authorizedUser()->id)
							$this->httpForbidden();

						else
							return $record;
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



	private function prepareRecord($permissionAction) {
		if ($this->authorizedUser()) {
			$permissionValue	= $this->permissionForModelAndAction('records', $permissionAction);

			if ($permissionValue == Permissions::ACCESS_NO_ACCESS)
				$this->httpForbidden();

			else {
				$postData			= $this->getParams('Record');
				$record				= new Records();

				if (isset($postData->text))
					$record->text		= $postData->text;

				if (isset($postData->datetime))
					$record->datetime	= $postData->datetime;

				if (isset($postData->calories))
					$record->calories	= $postData->calories;

				return $record;
			}
		}
		else
			$this->httpUnauthorized();

		return null;
	}



	/* Create Record */

	public function postAction() {
		$postRecord				= $this->prepareRecord(Permissions::ACTION_CREATE);

		if ($postRecord) {
			$postRecord->user_id	= $this->authorizedUser()->id;

			if ($postRecord->create()) {
				$this->httpCreated();
				$this->setResult($postRecord->toOutput());
			}
			else {
				$errors					= [];

				foreach ($postRecord->getMessages() as $message)
					$errors[]				= ValidationError::toOutput($message);
	
				$this->setErrors($errors);
				$this->httpBadRequest();
			}
		}

		return $this->respond();
	}



	/* Read Record */

	public function viewAction($record_id) {
		$record				= $this->getById($record_id, Permissions::ACTION_READ);

		if ($record)
			$this->setResult($record->toOutput());

		return $this->respond();
	}



	/* Update Record */

	public function putAction($record_id) {
		$record					= $this->getById($record_id, Permissions::ACTION_UPDATE);

		if ($record) {
			$postRecord				= $this->prepareRecord(Permissions::ACTION_UPDATE);

			if ($postRecord) {
				$postRecord->id			= $record->id;
				$postRecord->user_id	= $record->user_id;

				if ($postRecord->update()) {
					$this->httpOk();
					$this->setResult($postRecord->toOutput());
				}
				else {
					$errors					= [];

					foreach ($postRecord->getMessages() as $message)
						$errors[]				= ValidationError::toOutput($message);
		
					$this->setErrors($errors);
					$this->httpBadRequest();
				}
			}
		}

		return $this->respond();
	}



	/* Delete Record */

	public function deleteAction($record_id) {
		$record				= $this->getById($record_id, Permissions::ACTION_DELETE);

		if ($record) {
			if ($record->delete())
				$this->httpNoContent();

			else
				$this->httpInternalServerError();
		}

		return $this->respond();
	}
}
<?php




class Permissions extends AppModel {
	const ACCESS_NO_ACCESS		= 0;
	const ACCESS_MY_OWN_RECORDS	= 1;
	const ACCESS_ALL_RECORDS	= 2;

	const ACTION_CREATE			= 'create';
	const ACTION_READ			= 'read';
	const ACTION_UPDATE			= 'update';
	const ACTION_DELETE			= 'delete';

	public $id;
	public $group_id;
	public $model;
	public $create;
	public $read;
	public $update;
	public $delete;



	public function permissionForModelAndAction($model, $action = Permissions::ACTION_READ) {
		$model			= strtolower($model);
		$action			= strtolower($action);

		if ($this->model == '*' || strtolower($this->model) == $model)
			return intval($this->{$action});

		return Permissions::ACCESS_NO_ACCESS;
	}



	public function toOutput() {
		$permissionValue	= $this->permissionForAction();

		if ($permissionValue == Permissions::ACCESS_NO_ACCESS)
			return null;

		$group				= $this->authorizedGroup();

		if ($permissionValue == Permissions::ACCESS_ALL_RECORDS || (isset($group->id) && $group->id == $this->group_id))
			$result				= [
				'Permission'		=> [
					'id'				=> intval($this->id),
					'model'				=> strtolower($this->model),
					'create'			=> intval($this->create),
					'read'				=> intval($this->read),
					'update'			=> intval($this->update),
					'delete'			=> intval($this->delete)
				]
			];

		else
			return null;

		return $result;
	}
}
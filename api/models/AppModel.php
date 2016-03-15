<?php



use Phalcon\Mvc\Model;




class AppModel extends Model {



	public function authorizedUser() {
		return $this->getDI()->get('session')->get('User');
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



	public function permissionForAction($action = Permissions::ACTION_READ) {
		$group			= $this->authorizedGroup();
		$model			= strtolower($this->getSource());

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


}
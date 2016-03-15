<?php




class Groups extends AppModel {
	public $id;
	public $name;



	public function initialize() {
		$this->hasMany('id', 'Permissions', 'group_id');
	}



	public function toOutput() {
		$permissionValue	= $this->permissionForAction();

		if ($permissionValue == Permissions::ACCESS_NO_ACCESS)
			return null;

		$group				= $this->authorizedGroup();

		if ($permissionValue == Permissions::ACCESS_ALL_RECORDS || (isset($group->id) && $group->id == $this->id))
			$result				= [
				'Group'				=> [
					'id'				=> intval($this->id),
					'name'				=> $this->name
				]
			];

		else
			return null;

		$permissions		= $this->getPermissions();

		if ($permissions->count() > 0) {
			$perms				= [];	

			foreach ($permissions as $permission) {
				$output				= $permission->toOutput();

				if (!empty($output))
					$perms[]			= $output;
			}

			if (!empty($perms))
				$result['Group']['permissions']	= $perms;
		}

		return $result;
	}
}
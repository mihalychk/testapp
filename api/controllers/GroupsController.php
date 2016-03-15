<?php




class GroupsController extends AppController {



	/* List all groups */

	public function indexAction() {
		if ($this->authorizedUser()) {
			$groups				= [];

			switch ($this->permissionForModelAndAction('groups')) {
				case Permissions::ACCESS_MY_OWN_RECORDS:
					$groups				= Groups::find([
						'conditions'		=> 'id = :id:',
						'bind'				=> [
							'id'				=> $this->authorizedUser()->getGroups()->id
						]
					]);

					break;

				case Permissions::ACCESS_ALL_RECORDS:
					$groups				= Groups::find();

					break;

				default:
					$this->httpForbidden();

					break;
			}

			$result				= [];

			foreach ($groups as $group) {
				$output				= $group->toOutput();

				if ($output)
					$result[]			= $output;
			}

			$this->setResult($result);
		}
		else
			$this->httpUnauthorized();

		return $this->respond();
	}

}
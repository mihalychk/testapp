<?php




class ValidationError extends AppModel {



	public static function toOutput($message) {
		return [
			'ValidationError'	=> [
				'field'				=> $message->getField(),
				'message'			=> $message->getMessage(),
				//'type'				=> $message->getType()
			]];
	}

}
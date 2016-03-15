# API

API uses Phalcon Framework [https://phalconphp.com/en/], installation process described here [https://docs.phalconphp.com/en/latest/reference/install.html].


## API ANSWERS

```json
{
	"result" : null, // Results data: null, array or object
	"errors" : null, // Errors data: null or array
}
```


## AUTH

### GET `/api/auth` — Returns session info

Input: no params
Output:
	- HTTP 200 if ok,
	- HTTP 403 if no access,
	- HTTP 401 in token is invalid

```json
{
	"User" : {
		"id"               : 1,					// User's id in DB: int
		"name"             : "Michael",			// User's name: string
		"email"            : "email@email.com"	// User's email: string
		"calories_per_day" : 120.0				// User's daily calories limit
	},
	"Group" : {
		"id"          : 1,						// Group's id in DB: int
		"name"        : "Admin",				// Group's name: string
		"permissions" : [
			...,
			{
				"Permission" : {
					"id"      : 2,
					"model"   : "users",		// Model name: users, groups, permissions, records or * wildcard
					"create"  : 0,				// Permissions: int
					"read"    : 2,				// 0 — no access, 1 — only to my own records, 2 — to all records
					"update"  : 0,				//
					"delete"  : 0				//
				}
			},
			...
		]
	}
}
```


### POST `/api/auth` — Login user

Input:

```json
{
	"email"    : "email@email.com",
	"password" : "password"
}
```

Output:
	- HTTP 200 if ok,
	- HTTP 400 if error

```json
{
	"User" : {
		"id"               : 1,						// User's id in DB: int
		"name"             : "Michael",				// User's name: string
		"email"            : "email@email.com"		// User's email: string
		"calories_per_day" : 120.0					// User's daily calories limit
	},
	"Group" : {
		"id"          : 1,							// Group's id in DB: int
		"name"        : "Admin",					// Group's name: string
		"permissions" : [
			...,
			{
				"Permission" : {
					"id"      : 2,					// Permission's id in DB: int
					"model"   : "users",			// Model name: string (users, groups, permissions, records or * wildcard)
					"create"  : 0,					// Permissions: int
					"read"    : 2,					// 0 — no access, 1 — only to my own records, 2 — to all records
					"update"  : 0,					//
					"delete"  : 0					//
				}
			},
			...
		]
	},
	"auth_token" : "reeXPWK,P,OwhGRn76vA5IzsgZb"	// Auth token
}
```


### POST `/api/auth/new` — Register a new user

Input:

```json
{
	"email"    : "email@email.com",
	"name"     : "Michael",
	"password" : "password"
}
```

Output:
	- HTTP 200 if ok,
	- HTTP 400 if error

```json
{
	"User" : {
		"id"               : 1,						// User's id in DB: int
		"name"             : "Michael",				// User's name: string
		"email"            : "email@email.com"		// User's email: string
		"calories_per_day" : 120.0					// User's daily calories limit
	},
	"Group" : {
		"id"          : 1,							// Group's id in DB: int
		"name"        : "Admin",					// Group's name: string
		"permissions" : [
			...,
			{
				"Permission" : {
					"id"      : 2,					// Permission's id in DB: int
					"model"   : "users",			// Model name: string (users, groups, permissions, records or * wildcard)
					"create"  : 0,					// Permissions: int
					"read"    : 2,					// 0 — no access, 1 — only to my own records, 2 — to all records
					"update"  : 0,					//
					"delete"  : 0					//
				}
			},
			...
		]
	},
	"auth_token" : "reeXPWK,P,OwhGRn76vA5IzsgZb"	// Auth token
}
```


### DELETE `/api/auth` — Logout user

Input: no params
Output:
- HTTP 204 if ok,
- HTTP 400 if error,
- HTTP 403 if no access,
- HTTP 401 in token is invalid





## USERS


### GET `/api/users/{id}` — Returns user with id = {id}

Input: no params
Output:
- HTTP 200 if ok,
- HTTP 403 if no access,
- HTTP 404 if no user,
- HTTP 401 in token is invalid

```json
{
	"User" : {
		"id"               : 1,						// User's id in DB: int
		"name"             : "Michael",				// User's name: string
		"email"            : "email@email.com"		// User's email: string
		"calories_per_day" : 120.0					// User's daily calories limit
	},
	"Group" : {
		"id"          : 4,							// Group's id in DB: int
		"name"        : "User",						// Group's name: string
		"permissions" : [
			...,
			{
				"Permission" : {
					"id"      : 2,					// Permission's id in DB: int
					"model"   : "users",			// Model name: string (users, groups, permissions, records or * wildcard)
					"create"  : 0,					// Permissions: int
					"read"    : 2,					// 0 — no access, 1 — only to my own records, 2 — to all records
					"update"  : 0,					//
					"delete"  : 0					//
				}
			},
			...
		]
	}
}
```


### GET `/api/users` — Returns users list

Input: no params
Output:
- HTTP 200 if ok,
- HTTP 403 if no access,
- HTTP 401 in token is invalid

```json
[
	{
		"User" : {
			...
		}
	},
	{
		"User" : {
			...
		}
	},
	...,
	{
		"User" : {
			...
		}
	}
]
```


### POST `/api/users` — Creation of a new user

Input:

```json
{
	"User" : {
		"name"     : "Michael",				// User's name: string
		"email"    : "email@email.com"		// User's email, displays only to owner or superuser: string
		"password" : "password"				// User's password: string
	}
}
```

Output:
- HTTP 201 if ok,
- HTTP 400 if error,
- HTTP 403 if no access,
- HTTP 401 in token is invalid

```json
{
	"User" : {
		"id"               : 1,						// User's id in DB: int
		"name"             : "Michael",				// User's name: string
		"email"            : "email@email.com"		// User's email: string
		"calories_per_day" : 120.0					// User's daily calories limit
	},
	"Group" : {
		"id"          : 4,							// Group's id in DB: int
		"name"        : "User",						// Group's name: string
		"permissions" : [
			...,
			{
				"Permission" : {
					"id"      : 2,					// Permission's id in DB: int
					"model"   : "users",			// Model name: string (users, groups, permissions, records or * wildcard)
					"create"  : 0,					// Permissions: int
					"read"    : 2,					// 0 — no access, 1 — only to my own records, 2 — to all records
					"update"  : 0,					//
					"delete"  : 0					//
				}
			},
			...
		]
	}
}
```


### PUT `/api/users/{id}` — Update User

Input:

```json
{
	"User" : {
		"name"     : "Michael",				// User's name: string
		"email"    : "email@email.com"		// User's email, displays only to owner or superuser: string
		"password" : "password"				// User's password: string
	}
}
```

Output:
- HTTP 200 if ok,
- HTTP 400 if error,
- HTTP 403 if no access,
- HTTP 404 if no user,
- HTTP 401 in token is invalid

```json
{
	"User" : {
		"id"               : 1,						// User's id in DB: int
		"name"             : "Michael",				// User's name: string
		"email"            : "email@email.com"		// User's email: string
		"calories_per_day" : 120.0					// User's daily calories limit
	},
	"Group" : {
		"id"          : 4,							// Group's id in DB: int
		"name"        : "User",						// Group's name: string
		"permissions" : [
			...,
			{
				"Permission" : {
					"id"      : 2,					// Permission's id in DB: int
					"model"   : "users",			// Model name: string (users, groups, permissions, records or * wildcard)
					"create"  : 0,					// Permissions: int
					"read"    : 2,					// 0 — no access, 1 — only to my own records, 2 — to all records
					"update"  : 0,					//
					"delete"  : 0					//
				}
			},
			...
		]
	}
}
```


### DELETE `/api/users/{id}` — Delete User

Input: no params
Output:
- HTTP 204 if ok,
- HTTP 400 if error,
- HTTP 403 if no access,
- HTTP 404 if no user,
- HTTP 401 in token is invalid




## RECORDS


### GET `/api/records/{id}` — Returns the record with id = {id}

Input: no params
Output:
- HTTP 200 if ok,
- HTTP 403 if no access,
- HTTP 404 if no record,
- HTTP 401 in token is invalid

```json
{
	"Record" : {
		"id"       : 1,								// Record's id in DB: int
		"user_id"  : 4,								// Users's id in DB: int
		"text"     : "Tasty Burger",				// Meal name: string
		"datetime" : "2016-03-10T21:00:00+00:00",	// Date & time: string (ISO-8601)
		"calories" : 10.2							// Calories: float
	}
}
```


### GET `/api/records` — Returns records list

Input:
- params `time_from` and `time_to` time in 24 mode with minutes, ex. `18:00`
- params `date_from` and `date_to` datetime in ISO-8601, ex. `2016-03-10T21:00:00+00:00`

Output:
- HTTP 200 if ok,
- HTTP 403 if no access,
- HTTP 401 in token is invalid

```json
[
	{
		"Record" : {
			...
		}
	},
	{
		"Record" : {
			...
		}
	},
	...,
	{
		"Record" : {
			...
		}
	}
]
```


### POST `/api/records` — Creates a new record

Input:

```json
{
	"Record" : {
		"text"     : "Tasty Burger 2",				// Meal name: string
		"datetime" : "2016-03-10T21:00:00+00:00",	// Date & time: string (ISO-8601)
		"calories" : 14								// Calories: float
	}
}
```

Output:
- HTTP 200 if ok,
- HTTP 400 if error,
- HTTP 404 if no record,
- HTTP 401 in token is invalid

```json
{
	"Record" : {
		"id"       : 12,							// Record's id in DB: int
		"user_id"  : 4,								// Users's id in DB: int
		"text"     : "Tasty Burger 2",				// Meal name: string
		"datetime" : "2016-03-10T21:00:00+00:00",	// Date & time: string (ISO-8601)
		"calories" : 14								// Calories: float
	}
}
```


### PUT `/api/records/{id}` — Updates the record with id = {id}

Input:

```json
{
	"Record" : {
		"text"     : "Tasty Burger",				// Meal name: string
		"datetime" : "2016-03-10T21:00:00+00:00",	// Date & time: string (ISO-8601)
		"calories" : 10.2							// Calories: float
	}
}
```

Output:
- HTTP 200 if ok,
- HTTP 400 if error,
- HTTP 403 if no access,
- HTTP 404 if no record,
- HTTP 401 in token is invalid

```json
{
	"Record" : {
		"id"       : 1,								// Record's id in DB: int
		"user_id"  : 4,								// Users's id in DB: int
		"text"     : "Tasty Burger",				// Meal name: string
		"datetime" : "2016-03-10T21:00:00+00:00",	// Date & time: string (ISO-8601)
		"calories" : 10.2							// Calories: float
	}
}
```


### DELETE `/api/records/{id}` — Deletes the record with id = {id}

Input: no params
Output:
- HTTP 204 if ok,
- HTTP 403 if no access,
- HTTP 404 if no record,
- HTTP 401 in token is invalid



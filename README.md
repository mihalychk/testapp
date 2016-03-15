# Sample Application “Calories”

### Task

- User must be able to create an account and log in.
- Implement at least two roles with different permission levels (ie: a regular user would only be able to CRUD on his owned records, a user manager would be able to CRUD users, an admin would be able to CRUD on all records and users, etc.)
- When logged in, user can see a list of his meals and calories, user enters calories manually, also user should be able to edit and delete records.
- Each entry has a date, time, text, and num of calories
- Filter by dates from-to, time from-to.
- User setting – Expected number of calories per day.
- When displayed, it goes green if the total for that day is less than expected number of calories per day, otherwise goes red.
- REST API.

# API

API uses Phalcon Framework [https://phalconphp.com/en/], installation process described here [https://docs.phalconphp.com/en/latest/reference/install.html].


## API ANSWERS

```json
{
	"result" : null,
	"errors" : null
}
```

Results data: null, array or object. Errors data: null or array.


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
		"id"               : 1,
		"name"             : "Michael",
		"email"            : "email@email.com",
		"calories_per_day" : 120.0
	},
	"Group" : {
		"id"          : 1,
		"name"        : "Admin",
		"permissions" : [
			...,
			{
				"Permission" : {
					"id"      : 2,
					"model"   : "users",
					"create"  : 0, 
					"read"    : 2,
					"update"  : 0,
					"delete"  : 0
				}
			},
			...
		]
	}
}
```

Model name: users, groups, permissions, records or * wildcard. Permissions: int, 0 — no access, 1 — only to my own records, 2 — to all records.


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
		"id"               : 1,
		"name"             : "Michael",
		"email"            : "email@email.com",
		"calories_per_day" : 120.0
	},
	"Group" : {
		"id"          : 1,
		"name"        : "Admin",
		"permissions" : [
			...,
			{
				"Permission" : {
					"id"      : 2,
					"model"   : "users",
					"create"  : 0, 
					"read"    : 2,
					"update"  : 0,
					"delete"  : 0
				}
			},
			...
		]
	},
	"auth_token" : "reeXPWK,P,OwhGRn76vA5IzsgZb"
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
		"id"               : 1,
		"name"             : "Michael",
		"email"            : "email@email.com",
		"calories_per_day" : 120.0
	},
	"Group" : {
		"id"          : 1,
		"name"        : "Admin",
		"permissions" : [
			...,
			{
				"Permission" : {
					"id"      : 2,
					"model"   : "users",
					"create"  : 0, 
					"read"    : 2,
					"update"  : 0,
					"delete"  : 0
				}
			},
			...
		]
	},
	"auth_token" : "reeXPWK,P,OwhGRn76vA5IzsgZb"
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
		"id"               : 1,
		"name"             : "Michael",
		"email"            : "email@email.com",
		"calories_per_day" : 120.0
	},
	"Group" : {
		"id"          : 1,
		"name"        : "Admin",
		"permissions" : [
			...,
			{
				"Permission" : {
					"id"      : 2,
					"model"   : "users",
					"create"  : 0, 
					"read"    : 2,
					"update"  : 0,
					"delete"  : 0
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
		"name"     : "Michael",
		"email"    : "email@email.com",
		"password" : "password"
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
		"id"               : 1,
		"name"             : "Michael",
		"email"            : "email@email.com",
		"calories_per_day" : 120.0
	},
	"Group" : {
		"id"          : 1,
		"name"        : "Admin",
		"permissions" : [
			...,
			{
				"Permission" : {
					"id"      : 2,
					"model"   : "users",
					"create"  : 0, 
					"read"    : 2,
					"update"  : 0,
					"delete"  : 0
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
		"name"     : "Michael",	
		"email"    : "email@email.com",
		"password" : "password"
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
		"id"               : 1,
		"name"             : "Michael",
		"email"            : "email@email.com",
		"calories_per_day" : 120.0
	},
	"Group" : {
		"id"          : 1,
		"name"        : "Admin",
		"permissions" : [
			...,
			{
				"Permission" : {
					"id"      : 2,
					"model"   : "users",
					"create"  : 0, 
					"read"    : 2,
					"update"  : 0,
					"delete"  : 0
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
		"id"       : 1,
		"user_id"  : 4,
		"text"     : "Tasty Burger",
		"datetime" : "2016-03-10T21:00:00+00:00", 
		"calories" : 10.2
	}
}
```

Date & time: string, ISO-8601 [https://en.wikipedia.org/wiki/ISO_8601].


### GET `/api/records` — Returns records list

Input:
- params `time_from` and `time_to` time in 24 mode with minutes, ex. `18:00`
- params `date_from` and `date_to` datetime in ISO-8601 [https://en.wikipedia.org/wiki/ISO_8601], ex. `2016-03-10T21:00:00+00:00`

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
		"text"     : "Tasty Burger 2",
		"datetime" : "2016-03-10T21:00:00+00:00",
		"calories" : 14
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
		"id"       : 12,
		"user_id"  : 4,
		"text"     : "Tasty Burger 2",
		"datetime" : "2016-03-10T21:00:00+00:00",
		"calories" : 14
	}
}
```


### PUT `/api/records/{id}` — Updates the record with id = {id}

Input:

```json
{
	"Record" : {
		"text"     : "Tasty Burger",
		"datetime" : "2016-03-10T21:00:00+00:00",
		"calories" : 10.2
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
		"id"       : 1,
		"user_id"  : 4,
		"text"     : "Tasty Burger",
		"datetime" : "2016-03-10T21:00:00+00:00",
		"calories" : 10.2
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



# LocalizablesOrganizer

This is an app used to validate and sort localized files for iOS apps

The localizable.string file format should be:

``` swift
//MARK:- First Section's name
"FIRST_STRING_KEY" = "First string value";
"SECOND_STRING_KEY" = "Second string value";

//MARK:- Second Section's name
"THIRD_STRING_KEY" = "Third string value";
"FOURTH_STRING_KEY" = "Fourth string value";
```

###Sorting order

The app sorts the sections in order these are in the sections header array in the code. Planning to migrate to plist file or something.
Also, in each section, sorts the strings keys alphabetically.

###Validations
The app validates:

- If there is a comment without MARK
- If there are missing semi-colons (;)
- If there is a semi-colon without "
- If there is a empty key
- If there are duplicated keys
- Another issues

###Planning

- Migrate header strings to a plist file
- Sort headers alphabetically
- More validations
- Open from a file manager, and not copying the file content
- Save file
- List of headers and keys editable
- Search key

All these checkings have been added trying to add a new localizable file :D so if you found another issue, please add it to the code.

Thanks!

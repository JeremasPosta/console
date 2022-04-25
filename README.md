# Console 🖥
A challenge for Shipnow 🚚 📦.

Console is a filesystem simulation. It has the posibility to manage folders and simple text-based files.

## Restrictions
The project cannot use external API, Gems or libraries.

## Requirements
This was written on `Ruby 3.0.2`. Tested on Windows.

Works fine with `2.4.10`, `2.7.*`.

## Initialization
We can start our Console typing:

`ruby console.rb`

It can be augmented with some parameters, check it with:

`ruby console.rb --help`

```
Usage: console [options]
    -u, --user = 'example'           Your username
    -k, --password = 'example_pwd'   Your password
    -p, --persisted = 'fileName'     Your virtual disk filename if you want to persist data, without extension
    
Example $ruby .\console.rb  --persisted file -u jeremias -k ramirez
```
Once started, you will be prompted to insert your credentials if you not provided during start. Also will be displayed if you provide bad credentials.

Here, you can redefine your password indeed. (Not too secure, uh?) I need to fix it. 
```
> You can create your user now, login, or provide your credentials when starting Console.rb next time.
>> Username:
>> Password: 
```
Once logged, a prompt appear:
```
> Welcome Jere, if you are using --persisted option, quit with command 'quit' or 'exit' to save your changes.
jeremias@drive/>
```
Now you can work with the other commands.

## Commands
Other commands and its functions are:

| Command | Alias | Action |
| ------- | ----- | ------ |
| `exit` | `quit` | Close the Console and save changes if `--persisted` flag was provided|
| `clear` | `cls` | Clear the Console |
| `create_file filename "content" ` | `touch` | Create a new `filename` file with `content` |
| `show filename` |  | Show the file's content |
| `metadata filename` |  | Show the file's information |
| \*`create_folder foldername` | `mkdir` | Create a new `foldername` folder |
| `cd foldername` |  | Get into `foldername` if exists |
| \*`destroy file`, `destroy folder` | | Delete the desired element |
| `ls` |  | List the files and folder in the current folder |
| \*`mount diskname` |  | Read the information of a `diskname` file | 
| \*`dump diskname` |  | Write the actual data into file | 
| `ruby` |  | Allow us to evaluate any other Ruby sentence |
| `whoami` |  | Print the current user name |
| `whereami` |  | Print the current path |
| `seed` |  | Create some random files and folders |
| Any other command |  | Nothing, just print a newline |

 #### Notes:
 
`create_folder` If no name is provided, it will generate one.

`destroy` This is not currently working, Sorry! 😢

`mount` The file will be created if unexistent.

`dump` This can be done automatically on exit.

## Actual buggy behavior

* Cannot destroy Files nor Folders.
* User password can be overwritten from inside console, but a bad password is detected from flags.
* You can `cd` into a `file` and see its content.

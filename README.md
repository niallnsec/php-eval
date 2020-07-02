# php-eval
This is a simple PHP extension for hooking eval(). Credit goes to @mfmans

## Requirements
* PHP 7 (recommend)
* PHP 5.6.x (untested)

## Building and installing on Ubuntu

Start by installing the php-dev package. This will install all the necessary dependencies to build the extension.

```
sudo apt install php-dev
```

Next, clone the repository and configure the extension:

```
git clone https://github.com/niallnsec/php-eval
cd php-eval
phpize
./configure --enable-eval-hook
```

Finally, build and install:

```
make
sudo make install
```

In orer to activate the extension you need to add the following line to the relevent php.ini file. If you do not know which file to edit, running `php --ini` will show the configuration files currecntly in use.

```
extension=php_eval_hook
```

To validate the extension is installed and activated execute `php -m` to list all active modules and look for a line reading `eval`. If it is present then the module is active.


## Building and installing on Windows
* Download source code file `php_eval.c`
* Download PHP source code and prepare your PHP building environment (https://wiki.php.net/internals/windows/stepbystepbuild)
* Compile `php_eval.c` and build a DLL file with your Visual C++
* Copy the DLL file into PHP extension dir and install it by modifying php.ini
* Restart your server

## Usage
In order hook calls to eval, you must furst define a function with the prototype:

```php
function __eval($code, $file)
```

This function will be called first every time eval is called. To control what happens next, you have three options:

1. Return FALSE: This will prevent the code inside the $code variable from being executed.
2. Return a string value: The code in the returned string value will be compiled and executed instead of the original input stored in the $code argument.
3. Return nothing: If nothing is returned, the original input inside the $code argument will be compiled and executed.


The most basic example of usage is to print out eval'd code. This is extremely useful when deobfuscating PHP malware and other protected PHP files.

```php
<?php
function __eval($code, $file) {
	echo "eval() @ {$file}:\n{$code}\n\n";
}

eval('echo 1;');
```

Output:

```
[0] % php test.php
eval() @ /tmp/test.php(14) : eval()'d code:
echo 1;

1
```

You could also build a security check function to evaluate code being eval'd and execute conditionally.

```php
<?php
function __eval($code, $file) {
	if (preg_match("/\\$[a-z0-9_]*\(/i", $code)) {
		echo "Blocking eval with variable function call!\n\n";
		return false;
	}
	echo "eval() @ {$file}:\n{$code}\n\n";
}

eval('$func = \'system\'; echo $func("whoami");'); //This will be blocked
eval('echo 1;');
```

Ouptut:

```
[0] % php test.php
Blocking eval with variable function call!

eval() @ /tmp/test.php(12) : eval()'d code:
echo 1;

1
```

## License

MIT

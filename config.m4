PHP_ARG_ENABLE(php_eval_hook, Whether to enable the eval hook extension, [ --enable-eval-hook Enable Eval Hook])

if test "$PHP_EVAL_HOOK" != "no"; then
    PHP_NEW_EXTENSION(php_eval_hook, php_eval.c, $ext_shared)
fi

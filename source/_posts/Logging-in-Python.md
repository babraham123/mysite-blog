title: Logging in Python
date: 2014-08-23 17:04:58
tags:
---

Often times you want to log errors and debugging information in a log file. This is especially helpful for scripts that take a long time to run or run on a reoccurring basis. Below are some helpful hints and code snippets on how to do this in Python.

Include this code at the top of your script as a global variable. You can also use the same code to log info from helper scripts and imported libraries.

``` "python"
import logging
logger = logging.getLogger(__name__)
```

In your script's main function (the one that executes all of your code), you need to set the basic configuration params of the logger. This should only be called once. Set the name of the log file, formatting, etc. I like to call the log file the name of my main script, using sys.argv (remember to import sys)

``` "python"
if __name__ == "__main__":
    logname = sys.argv[0][:-3] + ".log"
    logging.basicConfig(level=logging.DEBUG, filename=logname, format='%(asctime)s %(levelname)s: %(name)s: %(message)s')
```

Finally, you can log messages to your log file in any .py file where you have initialized the logger object. 

``` "python"
def foo():
    logger.debug("Hello, world")
```

**Log levels** are a clever way to organize your log files. Typically you want a lot more information while debugging than while in production. Thus, you can send very description, long messages as `DEBUG` messages and shorter ones as `INFO` messages. Then you specify which log level you want when or set the configuration params. This determines which messages actually get written to your log file. The cool thing is that the log level X also gives you all of the log levels below X. So a log level of `WARNING` writes `WARNING`, `ERROR`, and `CRITICAL` messages to the log file. 

- `DEBUG`: Detailed information, typically of interest only when diagnosing problems.
- `INFO`: Confirmation that things are working as expected.
- `WARNING`: An indication that something unexpected happened, or indicative of some problem in the near future (e.g. ‘disk space low’). The software is still working as expected.
- `ERROR`: Due to a more serious problem, the software has not been able to perform some function.
- `CRITICAL`: A serious error, indicating that the program itself may be unable to continue running.

**How to catch Exceptions**
Certain commands are particularly error prone, like saving model objects in AnxPy. In that case, you want to catch and handle any exceptions, in order to prevent them from automatically terminating your program. You can catch all exceptions or only certain kinds. Here's an example:

``` "python"
try:
    # risky code
    my_creative.save()
except Exception as e:
    # failure
    message = "Creative " + str(my_creative.id) + " failed on save."
    logger.info(message)
    logger.exception(e)
else:
    # success!
    message = "Creative " + str(my_creative.id) + " was saved."
    logger.info(message)
```

**Advanced: Log all exceptions**
Insert this code at the top of your main script in order to log all exceptions, regardless of type or where they occur. They will still interrupt your program, but now they are also sent to your log file. Also, you can now decide whether or not to write to the standard error stream, stderr (useful for cron jobs). 

``` "python"
import logging, sys
logger = logging.getLogger(__name__)
 
def stderr_override(typeE, valueE, tracebackE):
    typeE = "\n  Error Type: " + str(typeE)
    valueE = "\n  Error Value: " + str(valueE)
    tracebackE = "\n  Traceback: " + "    ".join(traceback.format_tb(tracebackE)) + "\n"
    messageE = typeE + valueE + tracebackE
 
    logger.exception(messageE)
    print >> sys.stderr, messageE
 
# send any uncaught errors to the logs
sys.excepthook = stderr_override
```

import datetime
import os
import shutil
import subprocess
import sys

class logger(object):
    """
    Write to a log file, adding a final newline.
    We open, write then close as the tests also write to the file.
    """
    def __init__(self, _filename):
        self.filename = _filename

    def log(self, text):
        with open(self.filename, "a") as f:
            f.write(text+"\n")

def run_with_log(cmd, l):
    p = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        shell=True
    )
    (out, err) = p.communicate()
    out = out.decode(sys.stdout.encoding)
    err = err.decode(sys.stdout.encoding)
    loggable = ""
    for contents, name in [(out, "Output"), (err, "Error")]:
        if contents.strip():
            loggable += name+": \n"+contents+"\n"
    # we can't use the return value as this doesn't give us anything useful
    # on Windows (it's 0 for both fail or succeed)
    if "assertion fails" in out or "not completed" in loggable:
        l.log("Failed:\n---\n"+loggable.strip()+"\n---\n")
        return False
    else:
        l.log("Succeeded\n")
        return True

def main():
    dt = datetime.datetime.now().isoformat()[:-7]

    # log file is written wherever you run the code from
    l = logger(os.path.join(os.getcwd(),"test_"+dt+".out"))

    # Get path of this script.
    my_path = os.path.dirname(os.path.realpath(__file__))

    # Get all the tests, assuming that everything ending in .praat
    # in the tests/ directory is a test.
    tests = [x for x in os.listdir(my_path) if x.endswith('.praat')]
    l.log("Found tests:\n - "+"\n - ".join(tests))

    # Copy these to src/ if they're not there already.
    # This is because of the way praat "include" works.
    # Let's say we have files:
    #     src/phonolyzer.praat
    #     src/toolkit.praat
    #     test/test_phonolyzer.praat
    # The test can include the file it's testing as:
    #     include ../src/phonolyzer.praat
    # However, if phonolyzer.praat contains:
    #     include toolkit.praat
    # this will fail, as it looks in the current directory,
    # not relative to phonolyzer.praat.
    # So, we copy the tests to avoid imports from other directories.
    l.log("Copying to src/")
    for test in tests:
        src = os.path.join(my_path,test)
        dest = os.path.join(my_path,'..','src',test)
        if os.path.exists(src):
            shutil.copy(src, dest)
        else:
            # avoid copying if it already exists -- this means we can
            # edit the tests in src/ and still run this script.
            l.log(dest+" already exists, skipping.")

    # change directory to src, run tests
    os.chdir(os.path.join(my_path,'..','src'))
    n_tests, successes = len(tests), 0
    for test in tests:
        l.log("\n\n**** starting: "+test)
        # pass the log file name in to the test
        cmd = 'praat --run {testfile} {logfile}'.format(
            testfile=test, logfile=l.filename
        )
        l.log(cmd)
        successes += run_with_log(cmd, l)
        l.log("**** finished: "+test)

    report = "{fail} failures and {succ} successes of {tests} tests".format(
        fail=n_tests-successes, succ=successes, tests=n_tests
    )
    print(report)
    l.log(report)

    # Copy tests back to test/.
    # (This is for convenience while working on tests)
    for test in tests:
        src = os.path.join(my_path,'..','src',test)
        dest = os.path.join(my_path,test)
        shutil.copy(src, dest)

if __name__=='__main__':
    main()

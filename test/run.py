import os
import shutil
import subprocess

def main():

    # Get path of this script.
    my_path = os.path.dirname(os.path.realpath(__file__))

    # Get all the tests, assuming that everything ending in .praat
    # in the tests/ directory is a test.
    tests = [x for x in os.listdir(my_path) if x.endswith('.praat')]
    print("Found tests:\n - "+"\n - ".join(tests))

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
    print("Copying to src/")
    for test in tests:
        src = os.path.join(my_path,test)
        dest = os.path.join(my_path,'..','src',test)
        if os.path.exists(src):
            shutil.copy(src, dest)
        else:
            # avoid copying if it already exists -- this means we can
            # edit the tests in src/ and still run this script.
            print(dest+" already exists, skipping.")

    # change directory to src
    os.chdir(os.path.join(my_path,'..','src'))
    for test in tests:
        print("\n\n**** starting: "+test)
        cmd = "praat --run "+test
        print(cmd)
        subprocess.call(cmd, shell=True)
        print("**** finished: "+test)

if __name__=='__main__':
    main()

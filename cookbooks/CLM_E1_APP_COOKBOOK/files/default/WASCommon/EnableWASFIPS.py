############################
# Main
############################

import sys
import java.util as util
import java.io as javaio
import os
import shutil

print "enable FIPS"
AdminTask.enableFips('[-enableFips true -fipsLevel SP800-131 ]')
AdminConfig.save()

"""
This builder was created to address the way that tito builds tarballs,
it doesn't work for tomcat's spec. In an effort to keep the spec unchanged
I wrote this class to modify the behavior.
"""

from tito.builder import Builder

class ApacheTomcatTarBuilder(Builder):

    def _get_tgz_name_and_ver(self):
        """
        Returns the project name for the .tar.gz to build. Normally this is
        just the project name, but in the case of Satellite packages it may
        be different.
        """
        return "%s-%s-new" % (self.project_name, self.display_version)

from tito.builder import Builder

class ApacheTomcatTarBuilder(Builder):

    def _get_tgz_name_and_ver(self):
        """
        Returns the project name for the .tar.gz to build. Normally this is
        just the project name, but in the case of Satellite packages it may
        be different.
        """
        return "apache-%s-%s-src" % (self.project_name, self.display_version)

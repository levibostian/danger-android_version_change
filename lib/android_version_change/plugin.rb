
module Danger
  # Asserts the versionName or versionCode strings have been changed in your Android project.
  # This is done by checking the git diff of your project's build.gradle file.
  # The plugin will either call Danger's fail method or do nothing if the versionName or versionCode strings were changed.
  #
  # @example Assert the versionName string changed for your Android project
  #    # Calls Danger `fail` if the versionName not updated or nothing if it has changed.
  #   android_version_change.assert_version_name_changed()
  #
  #    # Calls Danger `fail` if the versionName not updated or nothing if it has changed.
  #   android_version_change.assert_version_code_changed()
  #
  # @tags android, ci, continuous integration, android version, danger, dangerfile, danger plugin
  class DangerAndroidVersionChange < Plugin
    # The instance name used in the Dangerfile
    # @return [String]
    #
    def self.instance_name
      "android_version_change"
    end

    def initialize(dangerfile)
      super(dangerfile)
    end

    # (Internal use) Pass the git diff string here to see if the version string has been updated.
    # @return [void]
    def assert_version_changed_diff(git_diff_string, name_or_code)
      git_diff_lines = git_diff_string.lines
      git_diff_string.each_line.each_with_index do |line, index|
        next unless line.include? name_or_code
        # we need to check the current line and the next line of the string to determine if it's a git diff change.
        if git_diff_lines.length >= (index + 2) && git_diff_lines[index][0] == "-" && git_diff_lines[index + 1][0] == "+"
          return # rubocop:disable NonLocalExitFromIterator
        end
      end

      fail "You did not change the Android " + name_or_code + "."
    end

    # (Internal use) Takes path to build.gradle as well as "versionName" or "versionCode" string to check for change.
    # @return [void]
    def assert_version_changed(override_build_gradle_file_path, name_or_code)
      build_gradle_file_path = override_build_gradle_file_path || "app/build.gradle"

      unless File.file?(build_gradle_file_path)
        fail "build.gradle file at path " + build_gradle_file_path + " does not exist."
        return # rubocop:disable UnreachableCode
      end

      unless git.diff_for_file(build_gradle_file_path) # No diff found for build.gradle file.
        fail "You did not edit your build.gradle file at all. Therefore, you did not change the " + name_or_code + "."
        return # rubocop:disable UnreachableCode
      end

      git_diff_string = git.diff_for_file(info_plist_file_path).patch
      assert_version_changed_diff(git_diff_string, name_or_code)
    end

    # Assert the versionName has been changed in your build.gradle file.
    #
    # @example Assert the versionName has been changed in your Android project.
    #    # Calls Danger `fail` if the versionName not updated or nothing if it has changed.
    #   android_version_change.assert_version_name_changed()
    #
    #   # If your build.gradle file is not located in the default location: `app/build.gradle`
    #   android_version_change.assert_version_name_changed("specialDirectory/build.gradle")
    #
    # @param [String] override_build_gradle_file_path
    #        (optional) Path to build.gradle file for Android project that versionName is located in.
    # @return [void]
    def assert_version_name_changed(override_build_gradle_file_path)
      assert_version_changed(override_build_gradle_file_path, "versionName")
    end

    # Assert the versionCode has been changed in your build.gradle file.
    #
    # @example Assert the versionCode has been changed in your Android project.
    #    # Calls Danger `fail` if the versionName not updated or nothing if it has changed.
    #   android_version_change.assert_version_code_changed()
    #
    #   # If your build.gradle file is not located in the default location: `app/build.gradle`
    #   android_version_change.assert_version_code_changed("specialDirectory/build.gradle")
    #
    # @param [String] override_build_gradle_file_path
    #        (optional) Path to build.gradle file for Android project that versionCode is located in.
    # @return [void]
    def assert_version_code_changed(override_build_gradle_file_path)
      assert_version_changed(override_build_gradle_file_path, "versionCode")
    end
  end
end

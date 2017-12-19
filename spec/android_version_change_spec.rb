require File.expand_path("../spec_helper", __FILE__)

module Danger
  describe Danger::DangerAndroidVersionChange do
    #
    # You should test your custom attributes and methods here
    #
    describe "with Dangerfile" do
      before do
        @dangerfile = testing_dangerfile
        @my_plugin = @dangerfile.android_version_change
      end

      # Some examples for writing tests
      # You should replace these with your own.

      it "Cannot find build.gradle file" do
        @my_plugin.assert_version_changed_diff("Foo/Bar/build.gradle", "versionName")
        expect(@dangerfile.status_report[:errors]).to eq(["buld.gradle at path Foo/Bar/buld.gradle does not exist."])
      end

      it "Fails from an empty git diff message" do
        @my_plugin.assert_version_changed_diff("", "versionName")
        expect(@dangerfile.status_report[:errors]).to eq(["You did not change the Android versionName."])
      end

      it "Successfully detects versionName changed" do
        diff = File.read("spec/ChangedVersionNameGitDiff.txt")
        @my_plugin.assert_version_changed_diff(diff, "versionName")
        expect(@dangerfile.status_report[:errors]).to eq([])
      end

      it "Successfully detects versionCode changed" do
        diff = File.read("spec/ChangedVersionCodeGitDiff.txt")
        @my_plugin.assert_version_changed_diff(diff, "versionCode")
        expect(@dangerfile.status_report[:errors]).to eq([])
      end

      it "Runs into end of git diff. This should never happen, but I need to test the built in error handling." do
        diff = File.read("spec/RunIntoEndOfFileGitDiff.txt")
        @my_plugin.assert_version_changed_diff(diff, "versionName")
        expect(@dangerfile.status_report[:errors]).to eq(["You did not change the Android versionName."])
      end

      it "versionName was not changed." do
        diff = File.read("spec/NotChangedVersionNameGitDiff.txt")
        @my_plugin.assert_version_changed_diff(diff, "versionName")
        expect(@dangerfile.status_report[:errors]).to eq(["You did not change the Android versionName."])
      end

      it "versionCode was not changed." do
        diff = File.read("spec/NotChangedVersionCodeGitDiff.txt")
        @my_plugin.assert_version_changed_diff(diff, "versionCode")
        expect(@dangerfile.status_report[:errors]).to eq(["You did not change the Android versionCode."])
      end
    end
  end
end

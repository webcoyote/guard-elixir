require 'spec_helper'
require "guard/watcher"
require "guard/ui"

describe "Guard-Elixir" do

  before(:each) do
    @subject = Guard::Elixir.new
    @paths   = [ "foo.ex", "dir1/dir2/dir3/bar.ex" ]
  end

  describe "initialize" do
    it "should start with default options" do
      @subject.options[:all_on_start].should be true
      @subject.options[:dry_run].should be false
    end

    it "should be possible to overwrite the default options" do
      @subject = Guard::Elixir.new([],{
        all_on_start: false,
        dry_run:      true
      })
      @subject.options[:all_on_start].should be false
      @subject.options[:dry_run].should be true
    end
  end

  describe "start" do
    describe "all_on_start" do
      it "should run all tests if all_on_start is true" do
        @subject = Guard::Elixir.new([],{ dry_run: true })
        @subject.should_receive(:run_all)
        @subject.start
      end
      it "should not run all tests on start if all_on_start is false" do
        @subject = Guard::Elixir.new([],{ all_on_start: false, dry_run: true })
        @subject.should_not_receive(:run_all)
        @subject.start
      end
    end
  end

  describe "run_on_change" do
    describe "dry run" do
      it "should not perform a conversion on a dry run" do
        @subject = Guard::Elixir.new([],{ dry_run: true })
        Kernel.should_not_receive(:exec)
        Guard::UI.should_receive(:info).exactly(@paths.count).times
        @subject.run_on_change(@paths)
      end
    end
  end

  describe "run_all" do
    it "should call run_on_change for all matching paths" do
      @subject = Guard::Elixir.new([],{ dry_run: true })
      Dir.should_receive(:glob).with("**/*.*").and_return(@paths)
      Guard::Watcher.should_receive(:match_files).with(@subject, @paths).and_return(@paths)
      @subject.should_receive(:run_on_change).with(@paths)
      @subject.run_all
    end

    describe "with change to mix.exs" do
      it "should call 'get_deps'" do
        paths = ["mix.exs"]
        @subject = Guard::Elixir.new([],{ dry_run: true })
        Dir.should_receive(:glob).with("**/*.*").and_return(paths)
        Guard::Watcher.should_receive(:match_files).with(@subject, paths).and_return(paths)
        @subject.should_receive(:get_deps)
        @subject.run_all
      end
    end
  end

end


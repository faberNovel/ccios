require_relative 'code_templater'
require 'fileutils'
require 'logger'

class Xcodeproj::Project::Object::PBXGroup

  def pf_new_group(associate_path_to_group:, name:, path:)
    # When using "Group with folder" we only provide a path
    # When using "Group without folder" we only provide a name
    new_group(
      associate_path_to_group ? nil : name,
      associate_path_to_group ? path : nil
    )
  end
end

class FileCreator

  def self.logger
    @@logger ||= create_logger
  end

  def logger
    FileCreator.logger
  end

  def initialize(options = {}, config)
    @options = options
    @config = config
  end

  def templater_options(target)
    defaults = {
      project_name: target.display_name,
      full_username: git_username,
      date: DateTime.now.strftime("%d/%m/%Y"),
    }
    defaults.merge(@options)
  end

  def git_username
    `git config user.name`.strip
  end

  def create_file(prefix, suffix, group, target)
    file_path = File.join(group.real_path, prefix + suffix + '.swift')

    raise "File #{file_path} already exists" if File.exist?(file_path)
    dirname = File.dirname(file_path)
    FileUtils.mkdir_p dirname unless File.directory?(dirname)
    file = File.new(file_path, 'w')

    templater_options = templater_options(target)
    code_templater = CodeTemplater.new(templater_options, @config.templates.path)
    file_content = code_templater.content_for_suffix(prefix, suffix)
    file.puts(file_content)

    file.close
    file_ref = group.new_reference(file_path)
    target.add_file_references([file_ref])
  end

  def create_empty_directory(group)
    dirname = group.real_path
    FileUtils.mkdir_p dirname unless File.directory?(dirname)

    git_keep_path = File.join(dirname, ".gitkeep")
    FileUtils.touch(git_keep_path) if Dir.empty?(dirname)
  end

  def print_file_content(prefix, suffix)
    file_name = suffix + '.swift'

    code_templater = CodeTemplater.new(@options, @config.templates.path)
    template = code_templater.content_for_suffix(prefix, suffix)

    logger.info "Add this snippet to #{file_name}"
    logger.info template
  end

  private

  def self.create_logger
    logger = Logger.new(STDOUT)
    logger.level = Logger::DEBUG
    logger.formatter = proc { |severity, datetime, progname, msg| msg + "\n" }
    logger
  end
end

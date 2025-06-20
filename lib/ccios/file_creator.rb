require_relative 'code_templater'
require 'fileutils'
require 'logger'
require 'xcodeproj'

class Xcodeproj::Project

  def project_name_from_path
    File.basename(@path, File.extname(@path))
  end
end

class FileCreator

  def self.logger
    @@logger ||= create_logger
  end

  def logger
    FileCreator.logger
  end

  def templater_options(targets, project)
    defaults = {
      full_username: git_username,
      date: DateTime.now.strftime("%d/%m/%Y"),
    }
    if project.nil?
      if targets.count == 1
        defaults["project_name"] = targets[0]
      else
        raise "A file outside an xcode project cannot require multiple targets"
      end
    else
      if targets.count == 1
        defaults["project_name"] = targets[0].display_name
      else
        defaults["project_name"] = project.project_name_from_path
      end
    end
    defaults
  end

  def git_username
    `git config user.name`.strip
  end

  def get_unknown_template_tags_for(template_path)
    tags = CodeTemplater.new.get_unknown_context_keys_for_template(template_path)
    tags.subtract(Set["project_name", "full_username", "date"])
    tags
  end

  def create_file_using_template_path(template_path, generated_filename, group, targets, project, context)
    file_path = File.join(group.real_path, generated_filename)

    raise "File #{file_path} already exists" if File.exist?(file_path)
    dirname = File.dirname(file_path)
    FileUtils.mkdir_p dirname unless File.directory?(dirname)
    file = File.new(file_path, 'w')

    context = context.merge(templater_options(targets, project))
    file_content = CodeTemplater.new.render_file_content_from_template(template_path, generated_filename, context)

    file.puts(file_content)

    file.close
    group.register_file_to_targets(file_path, targets)
  end

  def print_file_content_using_template(filename, template_path, context)
    file_content = CodeTemplater.new.render_file_content_from_template(template_path, filename, context)
    Mustache.render(File.read(template_path), context)

    logger.info "Add this snippet to #{filename}"
    logger.info file_content
  end

  def create_empty_directory_for_group(group)
    dirname = group.real_path
    create_empty_directory(dirname)
  end

  def create_empty_directory(dirname)
    FileUtils.mkdir_p dirname unless File.directory?(dirname)

    git_keep_path = File.join(dirname, ".gitkeep")
    FileUtils.touch(git_keep_path) if Dir.empty?(dirname)
  end

  private

  def self.create_logger
    logger = Logger.new(STDOUT)
    logger.level = Logger::DEBUG
    logger.formatter = proc { |severity, datetime, progname, msg| msg + "\n" }
    logger
  end
end

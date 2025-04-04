require_relative 'pbxproj_parser'

# This object handles Xcode groups, folder reference and synchronized folder reference
class XcodeGroupRepresentation
  def self.findGroup(path, project)
    intermediates_groups = path.split("/")

    if project.nil?
      return self.new nil, nil, intermediates_groups
    end

    deepest_group = project.main_group
    additional_path = []

    intermediates_groups.each do |group_name|
      if deepest_group.is_a?(Xcodeproj::Project::Object::PBXFileSystemSynchronizedRootGroup)
        additional_path.append(group_name)
      elsif deepest_group.is_a?(Xcodeproj::Project::Object::PBXGroup)
        deepest_group = deepest_group.find_subpath(group_name)
        return nil if deepest_group.nil?
        # return self.new nil, nil, additional_path
      else
        raise "Unsupported element found with name \"#{group_name}\": #{deepest_group}"
      end
    end
    self.new project, deepest_group, additional_path
  end

  def initialize(project, xcode_group, additional_path = [])
    # throw "Unsupported group type" unless xcode_group.is_a?(Xcodeproj::Project::Object::PBXFileSystemSynchronizedRootGroup) || xcode_group.is_a?(Xcodeproj::Project::Object::PBXGroup)
    # if !additional_path.empty? && !xcode_group.is_a?(Xcodeproj::Project::Object::PBXFileSystemSynchronizedRootGroup)
    #   throw "additional_path can only be specified for a synchronized file system group"
    # end
    @project = project # can be nil
    # This represents the deepest group or folder reference in the project
    @xcode_deepest_group = xcode_group # can be nil
    # This represents the additional filesystem path after `xcode_deepest_group` as an Array of strings. This should be non empty only when deepest group is a synchronized group
    @additional_path = additional_path
  end

  def real_path
    if @xcode_deepest_group.nil?
      @additional_path.join("/")
    else
      Xcodeproj::Project::Object::GroupableHelper.real_path(@xcode_deepest_group) + @additional_path.join("/")
    end
  end


  def register_file_to_targets(file_path, targets)
    if @xcode_deepest_group.nil?
      return
    end
    if @xcode_deepest_group.is_a?(Xcodeproj::Project::Object::PBXGroup)
      file_ref = @xcode_deepest_group.new_reference(file_path)
      targets.each do |target|
        target.add_file_references([file_ref])
      end
    else
      # no file to register, unless exceptions needs to be made
      # TODO: Handle synchronized groups (no new reference, but use exceptions)
      targets.each do |taget|
        puts "Unsupported target mismatch between \"#{file_path}\" and synchronized group #{ @xcode_deepest_group.display_name }" unless taget.file_system_synchronized_groups.index(@xcode_deepest_group) != nil
      end
    end
  end

  # @return [XcodeGroupRepresentation] the created group or self if the intermediates_groups is empty
  def create_groups_if_needed_for_intermediate_groups(intermediates_groups)
    return self if intermediates_groups.empty?

    new_deepest_group = @xcode_deepest_group
    new_additional_path = @additional_path

    intermediates_groups.each do |group_name|
      if new_deepest_group.is_a?(Xcodeproj::Project::Object::PBXFileSystemSynchronizedRootGroup) || new_deepest_group.nil?
        new_additional_path.append(group_name)
      elsif new_deepest_group.is_a?(Xcodeproj::Project::Object::PBXGroup)
        existing_child = new_deepest_group.find_subpath(group_name)
        new_group_path = File.join(new_deepest_group.real_path, group_name)
        new_deepest_group = existing_child || new_deepest_group.pf_new_group(
          associate_path_to_group: !new_deepest_group.path.nil?,
          name: group_name,
          path: new_group_path
        )
      else
        raise "Unsupported element found for \"#{group_name}\": #{new_deepest_group}"
      end
    end
    XcodeGroupRepresentation.new @project, new_deepest_group, new_additional_path
  end
end

# Private utility method

class Xcodeproj::Project::Object::PBXGroup
  def pf_new_group(associate_path_to_group:, name:, path:)
    new_group(
      associate_path_to_group ? nil : name,
      associate_path_to_group ? path : nil
    )
  end
end

require 'task_serializer'

class ShallowProjectSerializer < ActiveModel::Serializer
  attributes :unit_id, :project_id, :started, :progress, :status, :student_name, :tutor_name, :unit_name, :target_grade

  def project_id
    object.id
  end

  def student_name
    object.student.name
  end

  def unit_name
    object.unit.name
  end

  def tutor_name
    object.main_tutor.first_name unless object.main_tutor.nil?
  end

end

class StudentProjectSerializer < ActiveModel::Serializer
  attributes :project_id, :first_name, :last_name, :student_id, :student_email, :tute, :stats, :enrolled, :target_grade

  def student_email
    object.student.email
  end

  def project_id
    object.id
  end
  
  def first_name
    object.student.first_name
  end

  def last_name
    object.student.last_name
  end

  def student_id
    object.student.username
  end

  def tute
    object.unit_role.tutorial_id
  end  

  def stats
    if object.task_stats.nil? || object.task_stats.empty?
      object.update_task_stats
    else
      object.task_stats
    end
  end
end

class ProjectSerializer < ActiveModel::Serializer
  attributes :unit_id, :project_id, :started, :stats, :student_name, :tutor_name, :tute, :burndown_chart_data, :enrolled, :target_grade, :portfolio_files, :compile_portfolio, :portfolio_available

  def project_id
    object.id
  end

  def student_name
  	object.student.name
  end

  def tutor_name
  	object.main_tutor.first_name unless object.main_tutor.nil?
  end

  def tute
    object.unit_role.tutorial_id
  end

  def stats
    if object.task_stats.nil? || object.task_stats.empty?
      object.update_task_stats
    else
      object.task_stats
    end
  end

  def portfolio_available
    File.exists? object.portfolio_path
  end

  # has_one :unit, :unit_role
  has_many :tasks, serializer: ShallowTaskSerializer
end

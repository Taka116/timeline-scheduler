class UnivClass < ApplicationRecord
    require 'csv'
    
    belongs_to :user, optional: true
    has_many :univ_class_details, dependent: :destroy
    
    enum level: %i[
        language
        first_year_seminar_I
        first_year_seminar_II
        intermidiate_seminar
        advanced_seminar
        introductory_course
        intermidiate_course 
        advanced_course
        other_course
    ]
    
    validates :class_code, uniqueness: { scope: [:subject_name, :professor] }
    
    scope :with_univ_class_details, -> { includes(:univ_class_details) }
    scope :with_same_day, -> (day) { joins(:univ_class_details).merge( UnivClassDetail.with_day(day) )}
    scope :with_same_day_and_period_with_user, -> (user_id, days, periods) { UnivClass.where(user_id: user_id).joins(:univ_class_details).merge( UnivClassDetail.with_same_day_and_period(days, periods) ) }
    scope :with_same_day_and_period_without_user, -> (days, periods, levels) { UnivClass.where(level: levels).joins(:univ_class_details).merge( UnivClassDetail.with_same_day_and_period(days, periods) ) }

    def self.import(file)
        CSV.foreach(file.path, headers: true) do |row|
            univ_class = UnivClass.where(class_code: row["class_code"], subject_name: row["subject_name"], professor: row["professor"]).first
            if univ_class.nil?
                ##univ_class, evaluation
                if row["evaluation_system"] == nil
                    exam_evaluation, report_evaluation, normal_evaluation, other_evaluation = nil, nil, nil, nil
                else
                    evaluation_string = row["evaluation_system"].delete("''[],")
                    evaluation_string.include?("試験:") ? exam_position = evaluation_string.index("試験:") : exam_position = nil
                    evaluation_string.include?("レポート:") ? report_position = evaluation_string.index("レポート:") : report_position = nil
                    evaluation_string.include?("平常点評価:") ? normal_position = evaluation_string.index("平常点評価:") : normal_position = nil
                    if evaluation_string.include?('その他')
                        other_position = evaluation_string.index('その他:')
                    else
                        other_position = evaluation_string.index('備考・関連URL')
                    end
    
                    if !exam_position.nil? && !report_position.nil?
                        exam_evaluation = evaluation_string[ exam_position .. report_position-1]
                        if !report_position.nil? && !normal_position.nil?
                            report_evaluation = evaluation_string[ report_position .. normal_position-1 ]
                            if !normal_position.nil? && !other_position.nil?
                                normal_evaluation = evaluation_string[ normal_position .. other_position-1 ]
                                other_position.nil? ? other_evaluation = nil : other_evaluation = evaluation_string[ other_position .. evaluation_string.length ]
                            else
                                normal_evaluation = nil
                                other_position.nil? ? other_evaluation = nil : other_evaluation = evaluation_string[ other_position .. evaluation_string.length ]
                            end
                        elsif !report_position.nil? && !other_position.nil?
                            report_evaluation = evaluation_string[ report_position .. other_position-1 ]
                            normal_evaluation = nil
                            other_position.nil? ? other_evaluation = nil : other_evaluation = evaluation_string[ other_position .. evaluation_string.length ]
                        end
                    elsif !exam_position.nil? && !normal_position.nil?
                        exam_evaluation = evaluation_string[ exam_position .. normal_position-1]
                        if !normal_position && !other_position.nil?
                            report_evaluation = nil
                            normal_evaluation = evaluation_string[ normal_position .. other_position-1 ]
                            other_evaluation = evaluation_string[ other_position .. evaluation_string.length ]
                        else
                            report_evaluation, normal_evaluation = nil, nil
                            other_position.nil? ? other_evaluation = nil : other_evaluation = evaluation_string[ other_position .. evaluation_string.length ]
                        end
                    elsif !exam_position.nil? && !other_position.nil?
                        exam_evaluation = evaluation_string[ exam_position .. other_position-1]
                        report_evaluation, normal_evaluation = nil, nil
                        other_position.nil? ? other_evaluation = nil : other_evaluation = evaluation_string[ other_position .. evaluation_string.length ]
                    else
                        exam_evaluation, report_evaluation, normal_evaluation = nil, nil, nil
                        other_position.nil? ? other_evaluation = nil : other_evaluation = evaluation_string[ other_position .. evaluation_string.length ]
                    end
                end
                
                if ["英語I", "英語III", "その他外国語"].include?(row["level"])
                    level = "language"
                elsif ["Communication", "Culture, Mind and Body and Community", "Economy and Business", "Expression", "Governance, Peace, Human Rights and International Relations", "Philosophy, Religion and History", "Life, Environment, Matter and Information"].include?(row["level"])
                    level = "introductory_course"
                elsif ["基礎演習IＡ", "基礎演習IＢ"].include?(row["level"])
                    level = "first_year_seminar_I"
                elsif ["基礎演習IIＡ", "基礎演習IIＢ"].include?(row["level"])
                    level = "first_year_seminar_II"
                elsif row["level"] == "中級演習"
                    level = "intermidiate_seminar"
                elsif row["level"] == "上級演習"
                    level = "advanced_seminar"
                elsif row["level"] == "中級科目"
                    level = "intermidiate_course"
                elsif row["level"] == "上級科目"
                    level = "advanced_course"
                else
                    level = "other_course"
                end

                univ_class = UnivClass.create!(
                    class_code: row["class_code"],
                    subject_name: row["subject_name"],
                    professor: row["professor"],
                    number_of_credit: row["number_of_credit"],
                    class_url: row["class_url"],
                    content_of_class: row["content_of_class"],
                    level: level,
                    exam_evaluation: exam_evaluation,
                    report_evaluation: report_evaluation,
                    normal_evaluation: normal_evaluation,
                    other_evaluation: other_evaluation
                )
                univ_class.univ_class_details.create!(day: row["day"], period: row["period"].to_i, classroom: row["classroom"])
            else
                univ_class.univ_class_details.create!(day: row["day"], period: row["period"].to_i)
            end
        end
    end
end

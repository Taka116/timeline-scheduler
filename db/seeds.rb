
require 'csv'
CSV.foreach("db/class.csv", headers: true) do |row|
    univ_class = UnivClass.where(class_code: row["class_code"], subject_name: row["subject_name"], professor: row["professor"]).first
    if univ_class.nil?
        ##univ_class, evaluation
        if row["evaluation_system"] == nil
            exam_evaluation, report_evaluation, normal_evaluation, other_evaluation = "0%", "0%", "0%", "0%"
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
            
            if exam_position
                if report_position
                    exam_evaluation = evaluation_string[ exam_position+4 .. report_position-2]
                    if normal_position
                        report_evaluation = evaluation_string[ report_position+6 .. normal_position-2]
                        if other_position
                            normal_evaluation = evaluation_string[ normal_position+7 .. other_position-2]
                            other_evaluation = other_evaluation.present? ? evaluation_string[ other_position+5 .. evaluation_string.length] : "0%"
                        end
                    else
                        normal_evaluation = "0%"
                        other_evaluation = other_evaluation.present? ? evaluation_string[ other_position+5 .. evaluation_string.length] : "0%"
                    end
                else
                    report_evaluation, normal_evaluation = "0%", "0%"
                    other_evaluation = other_evaluation.present? ? evaluation_string[ other_position+5 .. evaluation_string.length] : "0%"
                end
            elsif report_position
                exam_evaluation = "0%"
                if normal_position
                    report_evaluation = evaluation_string[ report_position+6 .. normal_position-2]
                    if other_position
                        normal_evaluation = evaluation_string[ normal_position+7 .. other_position-2]
                        other_evaluation = other_evaluation.present? ? evaluation_string[ other_position+5 .. evaluation_string.length] : "0%"
                    end
                else
                    normal_evaluation = "0%"
                    other_evaluation = other_evaluation.present? ? evaluation_string[ other_position+5 .. evaluation_string.length] : "0%"
                end
            elsif normal_position
                exam_evaluation, report_evaluation = "0%", "0%"
                if other_position
                    normal_evaluation = evaluation_string[ normal_position+7 .. other_position-2]
                    other_evaluation = other_evaluation.present? ? evaluation_string[ other_position+5 .. evaluation_string.length] : "0%"
                end
            elsif other_position
                exam_evaluation = evaluation_string[ exam_position+4 .. other_position-2]
                report_evaluation, normal_evaluation = "0%", "0%"
            else
                exam_evaluation, report_evaluation, normal_evaluation = "0%", "0%", "0%"
                other_evaluation = other_evaluation.present? ? evaluation_string[ other_position+5 .. evaluation_string.length] : "0%"
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
            level = "intermediate_seminar"
        elsif row["level"] == "上級演習"
            level = "advanced_seminar"
        elsif row["level"] == "中級科目"
            level = "intermediate_course"
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

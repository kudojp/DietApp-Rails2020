module UserHelper
  def show_sex(user)
    if user.is_male.nil?
      nil
    else
      "Sex: #{user.is_male ? 'Male' : 'Female'}"
    end
  end

  def show_height(user)
    if user.height.nil?
      nil
    else
      "Height: #{user.height}"
    end
  end

  def show_weight(user)
    if user.weight.nil?
      nil
    else
      "Weight: #{user.weight}"
    end
  end

  def show_comment(user)
    if user.comment.nil?
      nil
    else
      "Comment: #{user.comment}"
    end
  end
end

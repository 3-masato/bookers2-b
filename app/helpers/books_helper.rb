module BooksHelper
  def empty_index_text(user)
    if user == current_user
      "There are no books posted. Share your thoughts on the books you have read!"
    else
      "This user has not submitted anything yet."
    end
  end

  def comparison_percentage(current_count, past_count)
    if past_count == 0
      "---"
    else
      ratio = current_count / past_count.to_f
      "#{(ratio * 100).round}%"
    end
  end
end

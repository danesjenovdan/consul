load Rails.root.join("app", "models", "comment_notifier.rb")

class CommentNotifier
    def email_on_comment?
      return false
    end

    def email_on_comment_reply?
      return false
    end
end

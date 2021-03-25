class PortfolioMailer < ApplicationMailer
  default from: "rykko.portfolio@outlook.com"

  def report_email
    @user = params[:user]
    attachments["report.pdf"] = File.read(params[:report_path])

    mail(to: @user.email, subject: "Your portfolio report")
  end
end

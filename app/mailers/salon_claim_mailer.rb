class SalonClaimMailer < ActionMailer::Base
  default :from => "no-reply@hairfolio.tech"

  def claim_approved(salon, password)
    @password = password
    @salon = salon
    @user = salon.owner
    mail(:to => salon.owner.email, :subject => 'Salon Claim Approved By Hairfolio')
  end
end

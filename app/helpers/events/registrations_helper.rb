module Events::RegistrationsHelper
  def confirmation_link(registration)
    registration.confirmed? ? "Waiting list" : "Confirm"
  end
end

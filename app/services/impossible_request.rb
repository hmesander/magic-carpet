class ImpossibleRequest < StandardError
  attr_reader :message,
              :status
  def initialize(message, status)
    @message = message
    @status = status
    super(@message)
  end
end
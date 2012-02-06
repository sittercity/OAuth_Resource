# Please see LICENSE.txt for copyright and license information.

# The Faraday Response Class
module Faraday
  class Response

    # ActiveResource expects the response object to respond to code,
    # whereas the Farday API exposes the status of the response via
    # the status method.
    #
    # Please see Faraday pull request #117
    #
    def code
      status
    end

  end
end

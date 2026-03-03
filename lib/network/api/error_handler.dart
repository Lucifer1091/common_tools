class ErrorHandler {
  ErrorHandler._();

  static String get(int? code, {String? body}) {
    switch (code) {
      // Informational (1xx)
      case 100:
        return 'Continue: The initial part of a request has been received.';
      case 101:
        return 'Switching Protocols: The server is switching protocols.';
      case 102:
        return 'Processing: The server has received and is processing the request.';
      case 103:
        return 'Early Hints: Preload resources before the final response.';

      // Successful (2xx)
      case 200:
        return 'OK: The request was successful.';
      case 201:
        return 'Created: The resource was successfully created.';
      case 202:
        return 'Accepted: The request has been accepted for processing.';
      case 203:
        return 'Non-Authoritative Information: The response is from a local or third-party copy.';
      case 204:
        return 'No Content: The request was successful but there is no content.';
      case 205:
        return 'Reset Content: Tell the client to reset the document view.';
      case 206:
        return 'Partial Content: The server is delivering part of the resource.';
      case 207:
        return 'Multi-Status: WebDAV-specific multi-status.';
      case 208:
        return 'Already Reported: WebDAV - already reported in a previous response.';
      case 226:
        return 'IM Used: Server has fulfilled a GET request with instance-manipulations.';

      // Redirection (3xx)
      case 300:
        return 'Multiple Choices: More than one resource is available.';
      case 301:
        return 'Moved Permanently: The resource has moved to a new URL.';
      case 302:
        return 'Found: The resource temporarily resides at a different URL.';
      case 303:
        return 'See Other: Redirect to a different URI.';
      case 304:
        return 'Not Modified: The resource has not been modified.';
      case 305:
        return 'Use Proxy: Must access the resource through the proxy.';
      case 306:
        return 'Unused: No longer used.';
      case 307:
        return 'Temporary Redirect: Resource temporarily resides at another URI.';
      case 308:
        return 'Permanent Redirect: Resource permanently resides at another URI.';

      // Client Error (4xx)
      case 400:
        return 'Bad Request: The server could not understand the request.';
      case 401:
        return 'Unauthorized: Authentication is required.';
      case 402:
        return 'Payment Required: Reserved for future use.';
      case 403:
        return 'Forbidden: You do not have access to this resource.';
      case 404:
        return 'Not Found: The resource could not be found.';
      case 405:
        return 'Method Not Allowed: Method is not allowed for the resource.';
      case 406:
        return 'Not Acceptable: Cannot generate a response acceptable by the client.';
      case 407:
        return 'Proxy Authentication Required: Authenticate with a proxy.';
      case 408:
        return 'Request Timeout: The request took too long.';
      case 409:
        return 'Conflict: The request could not be completed due to a conflict.';
      case 410:
        return 'Gone: The resource is no longer available.';
      case 411:
        return 'Length Required: Content-Length header is missing.';
      case 412:
        return 'Precondition Failed: Conditions in the request were not met.';
      case 413:
        return 'Payload Too Large: The request is too large.';
      case 414:
        return 'URI Too Long: The URI is too long to be processed.';
      case 415:
        return 'Unsupported Media Type: The media type is not supported.';
      case 416:
        return 'Range Not Satisfiable: Range cannot be fulfilled.';
      case 417:
        return 'Expectation Failed: Expectation header not met.';
      case 418:
        return "I'm a teapot: April Fools joke, not implemented.";
      case 421:
        return 'Misdirected Request: Request was directed to an incorrect server.';
      case 422:
        return 'Unprocessable Entity: Semantic errors in request.';
      case 423:
        return 'Locked: Resource is locked.';
      case 424:
        return 'Failed Dependency: Dependent request failed.';
      case 425:
        return 'Too Early: Server is unwilling to risk processing.';
      case 426:
        return 'Upgrade Required: Must switch protocols.';
      case 428:
        return 'Precondition Required: Preconditions must be specified.';
      case 429:
        return 'Too Many Requests: You have hit the rate limit.';
      case 431:
        return 'Request Header Fields Too Large: Headers too large.';
      case 451:
        return 'Unavailable For Legal Reasons: Resource blocked due to legal reasons.';

      // Server Error (5xx)
      case 500:
        return 'Internal Server Error: The server encountered an error.';
      case 501:
        return 'Not Implemented: Server does not support the functionality.';
      case 502:
        return 'Bad Gateway: Received invalid response from upstream server.';
      case 503:
        return 'Service Unavailable: The server is overloaded or under maintenance.';
      case 504:
        return 'Gateway Timeout: Did not receive a timely response.';
      case 505:
        return 'HTTP Version Not Supported: The HTTP version is not supported.';
      case 506:
        return 'Variant Also Negotiates: Internal configuration error.';
      case 507:
        return 'Insufficient Storage: Server is out of storage.';
      case 508:
        return 'Loop Detected: Infinite loop detected.';
      case 510:
        return 'Not Extended: Further extensions are required.';
      case 511:
        return 'Network Authentication Required: Authentication required for network access.';

      // Default fallback
      default:
        return 'Unexpected Error ($code): ${body ?? 'No additional details.'}';
    }
  }
}

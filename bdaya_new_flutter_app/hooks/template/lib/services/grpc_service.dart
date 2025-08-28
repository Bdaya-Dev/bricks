import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:grpc/service_api.dart';
import '../common.dart';

const kAcceptLanguageHeader = 'Accept-Language';
const grpcServerUrl = String.fromEnvironment(
  'grpc-url',
  defaultValue: 'default.server.com',
);

const grpcServerPort = int.fromEnvironment('grpc-port', defaultValue: 443);

const grpcServerTransportSecure =
    bool.fromEnvironment('grpc-secure', defaultValue: true);

class LoggingInterceptor extends ClientInterceptor {
  final Logger _logger = Logger('LoggingInterceptor');

  @override
  ResponseFuture<R> interceptUnary<Q, R>(
    ClientMethod<Q, R> method,
    Q request,
    CallOptions options,
    ClientUnaryInvoker<Q, R> invoker,
  ) {
    _logger.info('Request: ${method.path}, request: $request');
    final response = invoker(method, request, options);
    response.headers.then((r) {
      _logger.info('Response: $r');
    });

    response.trailers.then((r) {
      _logger.info('Response: $r');
    });
    return response;
  }

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
    ClientMethod<Q, R> method,
    Stream<Q> requests,
    CallOptions options,
    ClientStreamingInvoker<Q, R> invoker,
  ) {
    _logger.info('Request Stream: ${method.path}');
    requests.listen((request) {
      _logger.info('Request: $request');
    });

    final responseStream = invoker(method, requests, options);
    responseStream.listen((response) {
      _logger.info('Response: $response');
    });
    return responseStream;
  }
}

@realEnv
@lazySingleton
class GrpcService {
  Iterable<ClientInterceptor> get defaultInterceptors => [
        MyClientInterceptor(),
        LoggingInterceptor(),
      ];

  GrpcOrGrpcWebClientChannel get appDefaultChannel {
    return GrpcOrGrpcWebClientChannel.toSingleEndpoint(
      host: grpcServerUrl,
      port: grpcServerPort,
      transportSecure: grpcServerTransportSecure,
    );
  }

  // InvoicesSummaryReportsServiceClient get invoicesSummaryReportsServiceClient =>
  //     InvoicesSummaryReportsServiceClient(
  //       invoicesChannel,
  //       interceptors: {
  //         MyClientInterceptor(),
  //         LoggingInterceptor(),
  //       },
  //     );
}

///
/// response interceptor
class MyClientInterceptor extends ClientInterceptor {
  CallOptions getNewOptions(CallOptions options) {
    final l = getIt<BdayaAppThemeServiceBase>().locale.$;
    // final authService = getIt<AuthService>();
    // final token = authService.getToken();
    // final tenantId = authService.tenantIdRx.$;
    return options.mergedWith(
      CallOptions(
        metadata: {
          if (l != null) kAcceptLanguageHeader: l.languageCode,
          // if (token != null) kAuthorizationHeader: 'Bearer ' + token,
          // if (token == null && tenantId != null) kTenantHeader: tenantId,
        },
      ),
    );
  }

  @override
  ResponseFuture<R> interceptUnary<Q, R>(ClientMethod<Q, R> method, Q request,
      CallOptions options, ClientUnaryInvoker<Q, R> invoker) {
    final newOptions = getNewOptions(options);

    return invoker(method, request, newOptions);
  }

  @override
  ResponseStream<R> interceptStreaming<Q, R>(
      ClientMethod<Q, R> method,
      Stream<Q> requests,
      CallOptions options,
      ClientStreamingInvoker<Q, R> invoker) {
    final newOptions = getNewOptions(options);

    return invoker(method, requests, newOptions);
  }
}

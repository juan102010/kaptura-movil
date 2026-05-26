class WorkOrderTimeActionState {
  const WorkOrderTimeActionState({
    required this.isLoading,
    required this.errorMessage,
    required this.lastSuccessMessage,
  });

  final bool isLoading;
  final String? errorMessage;
  final String? lastSuccessMessage;

  factory WorkOrderTimeActionState.initial() {
    return const WorkOrderTimeActionState(
      isLoading: false,
      errorMessage: null,
      lastSuccessMessage: null,
    );
  }

  WorkOrderTimeActionState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? lastSuccessMessage,
    bool clearLastSuccessMessage = false,
  }) {
    return WorkOrderTimeActionState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      lastSuccessMessage: clearLastSuccessMessage
          ? null
          : (lastSuccessMessage ?? this.lastSuccessMessage),
    );
  }
}

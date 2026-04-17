enum ProposalStatus {
  pending,
  approved,
  rejected,
}

/// Propuesta de cambio en una comida planificada.
// Tiene ciclo de vida propio e independiente del plan semanal.
class PlanChangeProposal {
  final String id;
  final String familyId;
  final String weeklyPlanId;
  final String mealKey;
  final String proposedBy;
  final String currentRecipeId;
  final String proposedRecipeId;
  final ProposalStatus status;
  final DateTime proposalDate;

  const PlanChangeProposal({
    required this.id,
    required this.familyId,
    required this.weeklyPlanId,
    required this.mealKey,
    required this.proposedBy,
    required this.currentRecipeId,
    required this.proposedRecipeId,
    required this.status,
    required this.proposalDate,
  });
}
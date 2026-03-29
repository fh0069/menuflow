/// Define los estados posibles de una propuesta de cambio.
enum ProposalStatus {
  pending,
  approved,
  rejected,
}

/// Representa una propuesta de cambio en una comida planificada.
///
/// Permite a los miembros de una familia sugerir modificaciones
/// en el menú semanal, que posteriormente pueden ser aprobadas
/// o rechazadas por el administrador.
///
/// Esta entidad tiene un ciclo de vida propio y se gestiona
/// de forma independiente del plan semanal.
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
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/plan_change_proposal.dart';

/// Modelo de datos de [PlanChangeProposal] para Firestore.
///
/// Gestiona la conversión entre la entidad de dominio y
/// la representación almacenada en la base de datos.
class PlanChangeProposalModel extends PlanChangeProposal {
  const PlanChangeProposalModel({
    required super.id,
    required super.familyId,
    required super.weeklyPlanId,
    required super.mealKey,
    required super.proposedBy,
    required super.currentRecipeId,
    required super.proposedRecipeId,
    required super.status,
    required super.proposalDate,
  });

  factory PlanChangeProposalModel.fromMap(Map<String, dynamic> map) {
    return PlanChangeProposalModel(
      id: map['id'] as String,
      familyId: map['familyId'] as String,
      weeklyPlanId: map['weeklyPlanId'] as String,
      mealKey: map['mealKey'] as String,
      proposedBy: map['proposedBy'] as String,
      currentRecipeId: map['currentRecipeId'] as String,
      proposedRecipeId: map['proposedRecipeId'] as String,
      status: _statusFromString(map['status'] as String),
      proposalDate: (map['proposalDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'familyId': familyId,
      'weeklyPlanId': weeklyPlanId,
      'mealKey': mealKey,
      'proposedBy': proposedBy,
      'currentRecipeId': currentRecipeId,
      'proposedRecipeId': proposedRecipeId,
      'status': _statusToString(status),
      'proposalDate': Timestamp.fromDate(proposalDate),
    };
  }

  factory PlanChangeProposalModel.fromEntity(
      PlanChangeProposal entity) {
    return PlanChangeProposalModel(
      id: entity.id,
      familyId: entity.familyId,
      weeklyPlanId: entity.weeklyPlanId,
      mealKey: entity.mealKey,
      proposedBy: entity.proposedBy,
      currentRecipeId: entity.currentRecipeId,
      proposedRecipeId: entity.proposedRecipeId,
      status: entity.status,
      proposalDate: entity.proposalDate,
    );
  }

  static String _statusToString(ProposalStatus status) {
    switch (status) {
      case ProposalStatus.pending:
        return 'pending';
      case ProposalStatus.approved:
        return 'approved';
      case ProposalStatus.rejected:
        return 'rejected';
    }
  }

  static ProposalStatus _statusFromString(String value) {
    switch (value) {
      case 'pending':
        return ProposalStatus.pending;
      case 'approved':
        return ProposalStatus.approved;
      case 'rejected':
        return ProposalStatus.rejected;
      default:
        throw ArgumentError('Estado no válido: $value');
    }
  }
}
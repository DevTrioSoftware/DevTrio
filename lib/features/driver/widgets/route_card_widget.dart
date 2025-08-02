import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/route_model.dart';

class RouteCardWidget extends StatelessWidget {
  final RouteCard routeCard;
  final VoidCallback onAccept;
  final VoidCallback onTap;

  const RouteCardWidget({
    super.key,
    required this.routeCard,
    required this.onAccept,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: routeCard.isUrgent
            ? const BorderSide(color: Colors.red, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and urgent badge
              Row(
                children: [
                  Expanded(
                    child: Text(
                      routeCard.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (routeCard.isUrgent)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'ACİL',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 8),

              // Description
              Text(
                routeCard.description,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),

              const SizedBox(height: 12),

              // Route info
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.green, size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      routeCard.startLocation,
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              Row(
                children: [
                  Icon(Icons.flag, color: Colors.red, size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      routeCard.endLocation,
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Stats row
              Row(
                children: [
                  _buildStatItem(
                    icon: Icons.straighten,
                    label: '${routeCard.distance.toStringAsFixed(0)} km',
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 16),
                  _buildStatItem(
                    icon: Icons.access_time,
                    label: _formatDuration(routeCard.estimatedDuration),
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 16),
                  _buildStatItem(
                    icon: Icons.local_shipping,
                    label: routeCard.cargoType,
                    color: Colors.purple,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Payment and deadline row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '₺${routeCard.payment.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Teslim Tarihi',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      Text(
                        DateFormat(
                          'dd/MM/yyyy HH:mm',
                        ).format(routeCard.deadline),
                        style: TextStyle(
                          color: _getDeadlineColor(),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Customer info if available
              if (routeCard.customerName != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.business, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          routeCard.customerName!,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      if (routeCard.customerPhone != null)
                        IconButton(
                          icon: const Icon(
                            Icons.phone,
                            size: 18,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            // TODO: Launch phone call
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Arama: ${routeCard.customerPhone}',
                                ),
                              ),
                            );
                          },
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              // Accept button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: routeCard.isUrgent
                        ? Colors.red
                        : AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    routeCard.isUrgent
                        ? 'ACİL ROTA KABUL ET'
                        : 'ROTAYI KABUL ET',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    if (hours == 0) {
      return '${minutes}dk';
    } else if (minutes == 0) {
      return '${hours}sa';
    } else {
      return '${hours}sa ${minutes}dk';
    }
  }

  Color _getDeadlineColor() {
    final now = DateTime.now();
    final hoursUntilDeadline = routeCard.deadline.difference(now).inHours;

    if (hoursUntilDeadline < 2) {
      return Colors.red;
    } else if (hoursUntilDeadline < 6) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }
}

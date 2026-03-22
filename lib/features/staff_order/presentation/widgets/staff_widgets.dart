import 'package:flutter/material.dart';
import 'package:prm393_booking_app/features/staff_order/presentation/staff_design_system.dart';

/// Reusable Staff UI Components

/// Status badge widget
class StatusBadge extends StatelessWidget {
  final String status;
  final bool isSmall;

  const StatusBadge({
    required this.status,
    this.isSmall = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final color = StaffDesignSystem.getStatusColor(status);
    final label = StaffDesignSystem.getStatusLabel(status);
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: StaffDesignSystem.spacing8,
        vertical: isSmall ? StaffDesignSystem.spacing4 : StaffDesignSystem.spacing8,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(StaffDesignSystem.radiusSmall),
      ),
      child: Text(
        label,
        style: isSmall
            ? StaffTypography.labelSmall(isDark).copyWith(color: color)
            : StaffTypography.labelMedium(isDark).copyWith(color: color),
      ),
    );
  }
}

/// Table status badge widget
class TableStatusBadge extends StatelessWidget {
  final String status;
  final bool isSmall;

  const TableStatusBadge({
    required this.status,
    this.isSmall = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final color = StaffDesignSystem.getTableStatusColor(status);
    final isDark = context.isDarkMode;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: StaffDesignSystem.spacing8,
        vertical: isSmall ? StaffDesignSystem.spacing4 : StaffDesignSystem.spacing8,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(StaffDesignSystem.radiusSmall),
      ),
      child: Text(
        status,
        style: isSmall
            ? StaffTypography.labelSmall(isDark).copyWith(color: color)
            : StaffTypography.labelMedium(isDark).copyWith(color: color),
      ),
    );
  }
}

/// Metric card widget - for dashboard KPIs
class MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;
  final String? unit;
  final VoidCallback? onTap;

  const MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
    this.unit,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final bgColor = color ?? StaffDesignSystem.primary;
    final cardColor = context.cardColor;
    final borderColor = context.borderColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(StaffDesignSystem.spacing16),
        decoration: BoxDecoration(
          color: cardColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(StaffDesignSystem.radiusLarge),
          boxShadow: StaffDesignSystem.shadowLight,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: bgColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(StaffDesignSystem.radiusMedium),
              ),
              child: Icon(icon, color: bgColor, size: 22),
            ),
            const SizedBox(height: StaffDesignSystem.spacing12),
            Text(
              label,
              style: StaffTypography.bodySmall(isDark),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: StaffDesignSystem.spacing4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: StaffTypography.headlineSmall(isDark),
                ),
                if (unit != null) ...[
                  const SizedBox(width: StaffDesignSystem.spacing4),
                  Text(
                    unit!,
                    style: StaffTypography.bodySmall(isDark),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Quick action card - for tasks/shortcuts
class QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? description;
  final Color? color;
  final VoidCallback onTap;
  final bool isLoading;

  const QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
    this.description,
    this.color,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final bgColor = color ?? StaffDesignSystem.primary;
    final cardColor = context.cardColor;
    final borderColor = context.borderColor;

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(StaffDesignSystem.radiusLarge),
          boxShadow: StaffDesignSystem.shadowLight,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onTap,
            borderRadius: BorderRadius.circular(StaffDesignSystem.radiusLarge),
            child: Padding(
              padding: const EdgeInsets.all(StaffDesignSystem.spacing16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoading)
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(bgColor),
                        strokeWidth: 2,
                      ),
                    )
                  else
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: bgColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(StaffDesignSystem.radiusMedium),
                      ),
                      child: Icon(icon, color: bgColor, size: 24),
                    ),
                  const SizedBox(height: StaffDesignSystem.spacing12),
                  Text(
                    label,
                    style: StaffTypography.bodyMedium(isDark),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (description != null) ...[
                    const SizedBox(height: StaffDesignSystem.spacing4),
                    Text(
                      description!,
                      style: StaffTypography.bodySmall(isDark),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// List item card - for displaying menu items, orders, tables
class ListItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? trailing;
  final IconData? leadingIcon;
  final Color? leadingColor;
  final String? badge;
  final Color? badgeColor;
  final VoidCallback? onTap;
  final bool isSelected;

  const ListItemCard({
    required this.title,
    required this.subtitle,
    this.trailing,
    this.leadingIcon,
    this.leadingColor,
    this.badge,
    this.badgeColor,
    this.onTap,
    this.isSelected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final cardColor = context.cardColor;
    final borderColor = isSelected
        ? StaffDesignSystem.primary
        : context.borderColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(StaffDesignSystem.spacing12),
        decoration: BoxDecoration(
          color: cardColor,
          border: Border.all(
            color: borderColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(StaffDesignSystem.radiusMedium),
          boxShadow: isSelected ? StaffDesignSystem.shadowMedium : StaffDesignSystem.shadowLight,
        ),
        child: Row(
          children: [
            if (leadingIcon != null)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (leadingColor ?? StaffDesignSystem.primary).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(StaffDesignSystem.radiusSmall),
                ),
                child: Icon(
                  leadingIcon,
                  color: leadingColor ?? StaffDesignSystem.primary,
                  size: 20,
                ),
              )
            else
              const SizedBox(width: 40),
            const SizedBox(width: StaffDesignSystem.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: StaffTypography.titleSmall(isDark),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: StaffDesignSystem.spacing4),
                  Text(
                    subtitle,
                    style: StaffTypography.bodySmall(isDark),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: StaffDesignSystem.spacing12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: StaffDesignSystem.spacing8,
                  vertical: StaffDesignSystem.spacing4,
                ),
                decoration: BoxDecoration(
                  color: (badgeColor ?? StaffDesignSystem.primary).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(StaffDesignSystem.radiusSmall),
                ),
                child: Text(
                  badge!,
                  style: StaffTypography.labelSmall(isDark)
                      .copyWith(color: badgeColor ?? StaffDesignSystem.primary),
                ),
              ),
            ] else if (trailing != null) ...[
              const SizedBox(width: StaffDesignSystem.spacing12),
              Text(
                trailing!,
                style: StaffTypography.bodySmall(isDark),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Section header widget
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;
  final bool showDivider;

  const SectionHeader({
    required this.title,
    this.actionText,
    this.onAction,
    this.showDivider = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: StaffTypography.titleLarge(isDark),
            ),
            if (actionText != null && onAction != null)
              GestureDetector(
                onTap: onAction,
                child: Text(
                  actionText!,
                  style: StaffTypography.labelMedium(isDark)
                      .copyWith(color: StaffDesignSystem.primary),
                ),
              ),
          ],
        ),
        if (showDivider) ...[
          const SizedBox(height: StaffDesignSystem.spacing12),
          Divider(
            color: context.borderColor,
            height: 1,
          ),
        ],
      ],
    );
  }
}

/// App header widget for staff screens
class StaffAppHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onRefresh;
  final bool showRefresh;
  final List<Widget>? actions;

  const StaffAppHeader({
    required this.title,
    required this.subtitle,
    this.onRefresh,
    this.showRefresh = true,
    this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            StaffDesignSystem.spacing16,
            StaffDesignSystem.spacing8,
            StaffDesignSystem.spacing16,
            StaffDesignSystem.spacing16,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: StaffDesignSystem.primary.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(Icons.person_outline, size: 24),
              ),
              const SizedBox(width: StaffDesignSystem.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      subtitle,
                      style: StaffTypography.labelSmall(isDark),
                    ),
                    Text(
                      title,
                      style: StaffTypography.headlineSmall(isDark),
                    ),
                  ],
                ),
              ),
              if (showRefresh)
                IconButton(
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh),
                )
              else if (actions != null)
                Row(children: actions!),
            ],
          ),
        ),
      ],
    );
  }
}

/// Price display widget
class PriceWidget extends StatelessWidget {
  final double price;
  final bool isLarge;
  final String? prefix;

  const PriceWidget({
    required this.price,
    this.isLarge = false,
    this.prefix,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final formattedPrice = price.toStringAsFixed(0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        if (prefix != null) ...[
          Text(
            prefix!,
            style: isLarge
                ? StaffTypography.bodyMedium(isDark)
                : StaffTypography.bodySmall(isDark),
          ),
          const SizedBox(width: StaffDesignSystem.spacing4),
        ],
        Text(
          formattedPrice,
          style: isLarge
              ? StaffTypography.headlineSmall(isDark)
              : StaffTypography.titleMedium(isDark),
        ),
        const SizedBox(width: StaffDesignSystem.spacing4),
        Text(
          '₫',
          style: isLarge
              ? StaffTypography.bodyLarge(isDark)
              : StaffTypography.bodyMedium(isDark),
        ),
      ],
    );
  }
}

/// Empty state widget
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;

  const EmptyState({
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
    this.iconColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final color = iconColor ?? StaffDesignSystem.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(StaffDesignSystem.spacing32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: color),
            ),
            const SizedBox(height: StaffDesignSystem.spacing24),
            Text(
              title,
              style: StaffTypography.headlineSmall(isDark),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: StaffDesignSystem.spacing8),
            Text(
              description,
              style: StaffTypography.bodyMedium(isDark),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: StaffDesignSystem.spacing24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onAction,
                  child: Text(actionLabel!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

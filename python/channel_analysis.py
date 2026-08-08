"""Summarise an aggregated GA4 channel-performance export."""

from __future__ import annotations

import argparse
from pathlib import Path

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns


REQUIRED_COLUMNS = {
    "event_date",
    "source",
    "medium",
    "sessions",
    "engaged_sessions",
    "converting_sessions",
    "purchases",
    "revenue",
}


def load_data(path: Path) -> pd.DataFrame:
    data = pd.read_csv(path, parse_dates=["event_date"])
    missing = REQUIRED_COLUMNS.difference(data.columns)
    if missing:
        raise ValueError(f"Missing required columns: {sorted(missing)}")
    return data


def build_channel_summary(data: pd.DataFrame) -> pd.DataFrame:
    summary = (
        data.groupby(["source", "medium"], as_index=False)
        .agg(
            sessions=("sessions", "sum"),
            engaged_sessions=("engaged_sessions", "sum"),
            converting_sessions=("converting_sessions", "sum"),
            purchases=("purchases", "sum"),
            revenue=("revenue", "sum"),
        )
    )
    summary["engagement_rate"] = (
        summary["engaged_sessions"] / summary["sessions"]
    )
    summary["session_conversion_rate"] = (
        summary["converting_sessions"] / summary["sessions"]
    )
    summary["average_order_value"] = (
        summary["revenue"] / summary["purchases"].replace(0, pd.NA)
    )
    return summary.sort_values("revenue", ascending=False)


def save_revenue_chart(summary: pd.DataFrame, output_path: Path) -> None:
    chart_data = summary.head(10).copy()
    chart_data["channel"] = chart_data["source"] + " / " + chart_data["medium"]

    sns.set_theme(style="whitegrid")
    plt.figure(figsize=(10, 6))
    sns.barplot(data=chart_data, x="revenue", y="channel", color="#4285F4")
    plt.title("Revenue by acquisition channel")
    plt.xlabel("Revenue")
    plt.ylabel("")
    plt.tight_layout()
    plt.savefig(output_path, dpi=160)
    plt.close()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", type=Path, required=True)
    parser.add_argument("--output", type=Path, default=Path("outputs"))
    args = parser.parse_args()

    args.output.mkdir(parents=True, exist_ok=True)
    data = load_data(args.input)
    summary = build_channel_summary(data)
    summary.to_csv(args.output / "channel_summary.csv", index=False)
    save_revenue_chart(summary, args.output / "revenue_by_channel.png")


if __name__ == "__main__":
    main()

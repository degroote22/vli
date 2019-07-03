import { SaleHistoryResolvers } from "../gen/resolvers";
import { SaleHistoryDb } from "../db";

export const SaleHistory: SaleHistoryResolvers = {
  __resolveType: (parent, args) => {
    return (parent as SaleHistoryDb).type === "put"
      ? "SalePutHistory"
      : "SaleRemoveHistory";
  },
};

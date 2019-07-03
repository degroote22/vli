import { ItemForSaleResolvers } from "../gen/resolvers";
import { ItemForSaleDb, SaleContractModel } from "../db";

export const ItemForSale: ItemForSaleResolvers = {
  history: async (parent, args, context, info) => {
    const contracts = await SaleContractModel.find({
      _id: { $in: (parent as ItemForSaleDb)._contracts },
    });
    if (contracts.length == 0) {
      return [];
    }

    return contracts.map(x => x.history).reduce((p, c) => [...p, ...c], []);
  },
  contracts: async (parent, args, context, info) => {
    return await SaleContractModel.find({
      _id: { $in: (parent as ItemForSaleDb)._contracts },
    });
  },
};

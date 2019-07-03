import { SalePutHistoryResolvers } from "../gen/resolvers";
import { SalePutHistoryDb } from "../db";

export const SalePutHistory: SalePutHistoryResolvers = {
  when: async (parent, args, context, info) => {
    return (parent as SalePutHistoryDb)._when.toString();
    // return await ItemForSaleModel.find({
    // 	_id: { $in: (parent as AccountDb)._items },
    // });
  },
};

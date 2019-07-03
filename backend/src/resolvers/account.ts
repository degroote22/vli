import { AccountResolvers } from "../gen/resolvers";
import { ItemForSaleModel, IdentityModel, AccountDb } from "../db";

export const Account: AccountResolvers = {
  items: async (parent, args, context, info) => {
    return await ItemForSaleModel.find({
      _id: { $in: (parent as AccountDb)._items },
    });
  },

  identities: async (parent, args, context, info) => {
    return await IdentityModel.find({
      _id: { $in: (parent as AccountDb)._identities },
    });
  },

  hash: () => "",
};

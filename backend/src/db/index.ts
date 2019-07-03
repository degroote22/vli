// import * as mongoose from "mongoose";
const mongoose = require("mongoose");
// mongoose.connect("mongodb://localhost/vli", { useNewUrlParser: true });
mongoose.connect(
  "mongodb+srv://dgtdgt:dgtdgt@cluster0-l81bf.mongodb.net/test?retryWrites=true&w=majority",
  { useNewUrlParser: true },
);

import { prop, Typegoose, arrayProp, Ref } from "typegoose";

export class SaleHistoryDb extends Typegoose {
  @prop({ required: true })
  type!: "put" | "delete";

  @prop({ required: true })
  _id!: string;

  @prop({ required: true })
  _when!: Date;
  when!: string;

  @prop({ required: true })
  userGeneratedId!: string;

  // if put
  @prop()
  ammount?: number;

  @prop()
  latitude?: number;

  @prop()
  longitude?: number;

  // if delete
  @prop()
  removedId?: string;
}

export class SalePutHistoryDb extends Typegoose {
  @prop({ required: true })
  type!: "put";

  @prop({ required: true })
  _id!: string;

  @prop({ required: true })
  _when!: Date;
  when!: string;

  @prop({ required: true })
  userGeneratedId!: string;

  @prop({ required: true })
  ammount!: number;

  @prop({ required: true })
  latitude!: number;

  @prop({ required: true })
  longitude!: number;
}

export class SaleRemoveHistoryDb extends Typegoose {
  @prop({ required: true })
  type!: "delete";

  @prop({ required: true })
  _id!: string;

  @prop({ required: true })
  _when!: Date;
  when!: string;

  @prop({ required: true })
  userGeneratedId!: string;

  @prop({ required: true })
  removedId!: string;
}

export class ItemForSaleDb extends Typegoose {
  @prop({ required: true })
  _id!: string;

  @prop({ required: true })
  name!: string;

  @prop({ required: true })
  price!: string;

  @prop({ ref: { name: "AccountDb" }, required: true }) public _owner!: Ref<
    AccountDb
  >;

  @arrayProp({
    required: true,
    default: [],
    itemsRef: { name: "SaleContractDb" },
  })
  public _contracts!: Ref<SaleContractDb>[];

  // converte de referencia pra objeto no resolver
  owner!: AccountDb;
  contracts!: SaleContractDb[];

  // calculado no resolver
  history!: SaleHistoryDb[];
}

export class SaleContractDb extends Typegoose {
  @prop({ required: true })
  _id!: string;

  @prop({ required: true })
  ammount!: number;

  @prop({ ref: ItemForSaleDb, required: true })
  _selling!: Ref<ItemForSaleDb>;
  selling!: ItemForSaleDb;

  @arrayProp({
    required: true,
    default: [],
    items: SaleHistoryDb,
    _id: false,
  })
  history!: SaleHistoryDb[];

  @prop({ ref: { name: "IdentityDb" }, required: true }) public _seller!: Ref<
    IdentityDb
  >;
  // converte de referencia pra objeto no resolver
  seller!: IdentityDb;
}

export class AccountDb extends Typegoose {
  @prop({ required: true })
  _id!: string;

  @prop({ required: true })
  name!: string;

  @prop({ required: true })
  email!: string;

  @prop({ required: true })
  hash!: string;

  @arrayProp({ required: true, default: [], itemsRef: ItemForSaleDb })
  _items!: Ref<ItemForSaleDb>[];

  @arrayProp({ required: true, default: [], itemsRef: { name: "IdentityDb" } })
  public _identities!: Ref<IdentityDb>[];

  // O campo abaixo não é um campo do banco de dados
  // mas registra o formato do graphql.
  // TODO: garantir segurança de tipo nessas conversões!
  // A conversão é feita no 'resolver' da classe Identity.
  items!: ItemForSaleDb[];
  identities!: IdentityDb[];
}

export class IdentityDb extends Typegoose {
  @prop({ required: true })
  _id!: string;

  @prop({ required: true })
  name!: string;

  @prop({ required: true })
  sellerName!: string;

  @prop({ required: true, default: true })
  active!: boolean;

  @prop({ ref: AccountDb, required: true })
  _owner!: Ref<AccountDb>;

  // converte no resolver
  owner!: AccountDb;

  @arrayProp({ required: true, default: [], items: SaleContractDb })
  contracts!: SaleContractDb[];
}
export const SaleHistoryModel = new SaleHistoryDb().getModelForClass(
  SaleHistoryDb,
);
export const SalePutHistoryModel = new SalePutHistoryDb().getModelForClass(
  SalePutHistoryDb,
);
export const SaleRemoveHistoryModel = new SaleRemoveHistoryDb().getModelForClass(
  SaleRemoveHistoryDb,
);
export const ItemForSaleModel = new ItemForSaleDb().getModelForClass(
  ItemForSaleDb,
);
export const IdentityModel = new IdentityDb().getModelForClass(IdentityDb);
export const AccountModel = new AccountDb().getModelForClass(AccountDb);
export const SaleContractModel = new SaleContractDb().getModelForClass(
  SaleContractDb,
);

import { DataTypes } from 'sequelize';
import sequelize from '../config/db.js';

const Partner = sequelize.define('Partner', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    fullName: {
        type: DataTypes.STRING,
        allowNull: false,
        field: 'full_name'
    },
    email: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true
    },
    phone: {
        type: DataTypes.STRING,
        allowNull: false
    },
    city: {
        type: DataTypes.STRING,
        allowNull: false
    },
    partnerType: {
        type: DataTypes.STRING, // Using STRING to be flexible with PostgreSQL types
        allowNull: false,
        field: 'partner_type'
    },
    location: {
        type: DataTypes.TEXT,
        allowNull: false
    },
    locationOwnership: {
        type: DataTypes.STRING,
        allowNull: false,
        field: 'location_ownership'
    },
    status: {
        type: DataTypes.STRING,
        defaultValue: 'PENDING'
    },
    createdAt: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
        field: 'created_at'
    }
}, {
    tableName: 'partners',
    timestamps: false // We are managing created_at manually or via default
});

export default Partner;
